class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    conditions = {term: 'Privacy Act of 1974', agencies: 'defense-department'}
    fields = ['title', 'full_text_xml_url', 'html_url'] #, 'raw_text_url', 'agency_names', 'dates']
    search_options = {
      conditions: conditions,
      type: 'NOTICE',
      fields: fields,
      order: 'newest',
      per_page: 1000,
      page: 1
    }

    search_fed_reg(search_options)
  end

  def search_fed_reg(search_options)
    result_set = FederalRegister::Document.search(search_options)
    result_set.results.each do |result|
      if result.title.include? 'Privacy Act of 1974'
        ParseSornXmlJob.perform_later(result.full_text_xml_url, result.html_url)
      end

      if result_set.results.last == result
        search_options[:page] = search_options[:page] + 1
        if search_options[:page] <= result_set.total_pages
          search_fed_reg(search_options)
        end
      end
    end
  end
end
