class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Makes queries to the Federal Register API to find SORNs.
    # Searching for 'Privacy Act of 1974; System of Records' of type 'Notice' is the best query we have found.
    # In the results we still filter on those with a title that includes 'Privacy Act of 1974'.


    conditions = { term: 'Privacy Act of 1974; System of Records' }#, agencies: ['general-services-administration'] }
    # 'general-services-administration', 'justice-department', 'defense-department']
    fields = ["action", "agencies", "agency_names", "citation",
      "dates", "full_text_xml_url", "html_url", "pdf_url",
      "publication_date", "raw_text_url", "title", "type"]

    # unfortunately the ruby gem doesn't have the year filter implemented, only specific dates.
    # we may want to start using the http api instead.

    search_options = {
      conditions: conditions,
      type: 'NOTICE', # doesn't seem to work
      fields: fields,
      order: 'newest', #oldest
      per_page: 200,
      page: 1
    }

    search_fed_reg(search_options)
  end

  def search_fed_reg(search_options)
    puts 'Asking for SORNs'
    result_set = FederalRegister::Document.search(search_options)

    result_set.results.each do |result|
      next unless result.type == 'Notice'
      next unless result.title.include?('Privacy Act of 1974')

      sorn = Sorn.find_by(citation: result.citation)

      params = {
        action: result.action,
        dates: result.dates,
        xml_url: result.full_text_xml_url,
        html_url: result.html_url,
        pdf_url: result.pdf_url,
        text_url: result.raw_text_url,
        publication_date: result.publication_date,
        citation: result.citation,
        title: result.title,
        data_source: :fedreg
      }



      if not sorn
        sorn = Sorn.create!(params)
        # Create agencies
        result.agencies.each do |agency|
          agency = Agency.find_or_create_by(name: agency[:name], api_id: agency[:id], parent_api_id: agency[:parent_id])
          agency.sorns << sorn
          sorn.agencies << agency
        end



        puts "Created #{sorn.citation}"
       else
        # Only need to update agencies once
        # can remove this block after agencies are updated.
        if sorn.agencies.nil?
          result.agencies.each do |agency|
            agency = Agency.find_or_create_by(name: agency[:name], api_id: agency[:id], parent_api_id: agency[:parent_id])
            agency.sorns << sorn
            sorn.agencies << agency
          end
        end
        sorn.update(**params)
      end

      ParseSornXmlJob.perform_later(sorn.id)
    end

    # Keep making more requests until there are no more.
    search_options[:page] = search_options[:page] + 1
    if search_options[:page] <= result_set.total_pages
      search_fed_reg(search_options)
    end
  end

  private

  # def a_sorn_title?(title)
  #   includes_privacy_act = title.include?('Privacy Act of 1974')
  #   excludes_unwanted_titles = ['matching', 'rulemaking', 'implementation'].all? do |excluded_title|
  #     title.downcase.exclude? excluded_title
  #   end
  #   includes_privacy_act && excludes_unwanted_titles
  # end
end
