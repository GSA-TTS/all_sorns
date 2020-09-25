class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Makes queries to the Federal Register API to find SORNs.
    # Searching for 'Privacy Act of 1974; System of Records' of type 'Notice' is the best query we have found.
    # In the results we still filter on those with a title that includes 'Privacy Act of 1974'.


    conditions = { term: 'Privacy Act of 1974; System of Records', agencies: 'general-services-administration' }#,'justice-department']} #'defense-department',
    fields = ['title', 'full_text_xml_url' ]# , 'html_url'] #, 'raw_text_url', 'agency_names', 'dates']
    # unfortunately the ruby gem doesn't have the year filter implemented, only specific dates.
    search_options = {
      conditions: conditions,
      type: 'NOTICE',
      fields: fields,
      order: 'newest', #oldest
      per_page: 1000,
      page: 1
    }

    search_fed_reg(search_options)
  end

  def search_fed_reg(search_options)
    result_set = FederalRegister::Document.search(search_options)
    result_set.results.each do |result|

      if result.title.include?('Privacy Act of 1974')
        if result.title.exclude?('Matching') && result.title.exclude?('rulemaking') # Implementation
          ParseSornXmlJob.perform_later(result.full_text_xml_url)
        end
      end

      # Keep making more requests until there are no more.
      if result_set.results.last == result
        search_options[:page] = search_options[:page] + 1
        if search_options[:page] <= result_set.total_pages
          search_fed_reg(search_options)
        end
      end
    end
  end
end
