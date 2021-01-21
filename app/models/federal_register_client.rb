class FederalRegisterClient
  def initialize(conditions: nil, fields: nil)
    # Makes queries to the Federal Register API to find SORNs.
    # Searching for 'Privacy Act of 1974; System of Records' of type 'Notice' is the best query we have found.
    @conditions = conditions || { term: 'Privacy Act of 1974; System of Records' } #, agencies: ['general-services-administration']

    # Find all available fields at
    # https://github.com/usnationalarchives/federal_register/blob/master/lib/federal_register/document.rb#L4
    @fields = fields || ["action", "agencies", "citation",
                        "dates", "full_text_xml_url", "html_url", "pdf_url",
                        "publication_date", "raw_text_url", "title", "type"]

    @page = 1

    @search_options = {
      conditions: @conditions,
      type: 'NOTICE', # doesn't seem to work
      fields: @fields,
      order: 'newest', #oldest
      per_page: 200,
      page: @page
    }
  end

  def find_sorns
    puts 'Asking for SORNs'
    result_set = FederalRegister::Document.search(@search_options)

    result_set.results.each do |result|
      # type and title check happen here, instead of in handle_result
      # so that add_sorn_by_url can be used to add sorns without the expected types and titles
      handle_result(result) if sorn_result?(result)
    end

    # Keep making more requests until there are no more.
    @search_options[:page] += 1
    if @search_options[:page] <= result_set.total_pages
      find_sorns
    else
      FullSornSearch.refresh # refresh the materialilzed view to include the new SORNs found
    end
  end

  def add_sorn_by_url(fed_reg_url)
    # Be careful to only add SORNs, doesn't check for usual titles, on purpose
    document_number =  URI(fed_reg_url).path.split("/")[5]
    result = FederalRegister::Document.find(document_number, fields: @fields)
    handle_result(result)
  end

  private

  def handle_result(result)
    sorn = Sorn.find_by(citation: result.citation)

    params = sorn_params(result)

    if sorn
      sorn.update(**params)
    else
      sorn = Sorn.create(params)
    end

    add_agencies(result, sorn)

    UpdateSornJob.perform_later(sorn.id)
  end

  def a_sorn_title?(title)
    # We researched all Federal Register search result titles
    # https://docs.google.com/document/d/15gwih9P6ebazWCS2ekxQ5Id1rDWbktg1mFdXtHIPZ44/edit#
    # If a title includes one of these three, then we consider it a SORN.
    patterns = ['privacy act', 'system[\ssof]*record', 'computer match']
    patterns.any? { |pattern| title.match?(/#{pattern}/i) }
  end

  def sorn_result?(result)
    result.type == 'Notice' && a_sorn_title?(result.title)
  end

  def sorn_params(result)
    {
      agency_names: get_nice_agency_names(result),
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
  end

  def add_agencies(result, sorn)
    # add agency to sorn, without duplicates
    result.agencies.each do |api_agency|
      agency = build_agency(result, api_agency)
      if agency.present? && sorn.agencies.exclude?(agency)
        sorn.agencies << agency
      end
    end
  end

  private

  def get_agency_short_name(agency_api_id)
    FederalRegister::Agency.find(agency_api_id).short_name
  end

  def get_nice_agency_names(result)
    result.agencies.map do |api_agency|
      if api_agency.name == "Office of the Secretary"
        api_agency.name
      else
        api_agency.raw_name.titleize
      end
    end.join(" | ")
  end

  def build_agency(result, api_agency)
    if api_agency.id.present? # skip the subcomponents without metadata, "Office of the Secretary"
      agency = Agency.find_by(api_id: api_agency.id)
      if agency.nil?
        agency = Agency.create(
          name: api_agency.raw_name.titleize,
          api_id: api_agency.id,
          parent_api_id: api_agency.parent_id,
          short_name: get_agency_short_name(api_agency.id)
        )
      elsif agency.short_name.nil? # Can remove after everyone has short_name locally
        agency.update(short_name: get_agency_short_name(api_agency.id))
      end
      return agency
    end
  end
end
