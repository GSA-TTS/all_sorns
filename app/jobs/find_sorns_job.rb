class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Makes queries to the Federal Register API to find SORNs.
    # Searching for 'Privacy Act of 1974; System of Records' of type 'Notice' is the best query we have found.
    # In the results we still filter on those with a title that includes 'Privacy Act of 1974'.


    conditions = { term: 'Privacy Act of 1974; System of Records' }#, agencies: ['general-services-administration'] }
    # 'general-services-administration', 'justice-department', 'defense-department']
    fields = ['title', 'full_text_xml_url', 'html_url', 'citation']#, 'raw_text_url', 'agency_names', 'dates']
    # unfortunately the ruby gem doesn't have the year filter implemented, only specific dates.
    search_options = {
      conditions: conditions,
      type: 'NOTICE',
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

      next unless a_sorn_title?(result.title)
      # next if Sorn.find_by(citation: result.citation)

      params = {
        xml_url: result.full_text_xml_url,
        html_url: result.html_url,
        citation: result.citation
      }
      ParseSornXmlJob.perform_later(params)
    end

    # Keep making more requests until there are no more.
    search_options[:page] = search_options[:page] + 1
    if search_options[:page] <= result_set.total_pages
      search_fed_reg(search_options)
    end
  end

  private

  def a_sorn_title?(title)
    includes_privacy_act = title.include?('Privacy Act of 1974')
    excludes_unwanted_titles = ['matching', 'rulemaking', 'implementation'].all? do |excluded_title|
      title.downcase.exclude? excluded_title
    end
    includes_privacy_act && excludes_unwanted_titles
  end
end
