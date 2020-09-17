class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    conditions = {term: 'Privacy Act of 1974' } #, agencies: 'general-services-administration'}
    fields = ['title', 'full_text_xml_url' ]#, 'html_url', 'raw_text_url', 'agency_names', 'dates']
    options = {
      conditions: conditions,
      type: 'NOTICE',
      fields: fields,
      order: 'newest',
      per_page: 60
    }
    result_set = FederalRegister::Document.search(options)
    result_set.results.each do |result|
      if result.title.include? 'Privacy Act of 1974'
        ParseSornXmlJob.perform_later(result.full_text_xml_url)
        # ParseSornHTMLJob.perform_later(result.html_url)
        # ParseSornTextJob.perform_later(result.raw_text_url)
      end
    end
  end
end
