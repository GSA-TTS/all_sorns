class FederalRegisterApi
  def self.find_sorns
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

  def self.search_fed_reg(search_options)

    puts 'Asking for SORNs'
    result_set = FederalRegister::Document.search(search_options)

    result_set.results.each do |result|
      handle_result(result)
    end

    # Keep making more requests until there are no more.
    search_options[:page] = search_options[:page] + 1
    if search_options[:page] <= result_set.total_pages
      search_fed_reg(search_options)
    end
  end

  def self.handle_result(result)
    if result.type == 'Notice' && a_sorn_title?(result.title)
      sorn = Sorn.find_by(citation: result.citation)

      params = sorn_params(result)

      if sorn
        sorn.update(**params)
      else
        sorn = Sorn.create(params)

        # Create agencies
        result.agencies.each do |api_agency|
          agency = Agency.find_or_create_by(name: api_agency.name, api_id: api_agency.id, parent_api_id: api_agency.parent_id)
          sorn.agencies << agency
        end
      end

      ParseSornXmlJob.perform_later(sorn.id)
    end
  end

  def self.add_sorn_by_url(fed_reg_url)
    document_number =  URI(fed_reg_url).path.split("/")[5]
    result = FederalRegister::Document.find(document_number)
    handle_result(result)
  end

  private

  def self.a_sorn_title?(title)
    # We researched all Federal Register search result titles
    # https://docs.google.com/document/d/15gwih9P6ebazWCS2ekxQ5Id1rDWbktg1mFdXtHIPZ44/edit#
    # If a title includes one of these three, then we consider it a SORN.
    title.match?(/privacy act/i) ||
      title.match?(/system[\ssof]*record/i) ||
        title.match?(/computer match/i)
  end

  def self.sorn_params(result)
    {
      action: result.action,
      dates: result.dates,
      xml_url: result.full_text_xml_url,
      html_url: result.html_url,
      pdf_url: result.pdf_url,
      text_url: result.raw_text_url,
      publication_date: result.publication_date,
      citation: result.citation,
      title: result.title,
      agency_names: result.agency_names,
      data_source: :fedreg
    }
  end
end