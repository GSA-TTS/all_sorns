namespace :federal_register do
  desc "Find new SORNs on the Federal Register API"
  task find_sorns: :environment do
    FindSornsJob.perform_later
  end
end

namespace :all_sorns do
  desc "Find new SORNs on the Federal Register API"
  task update_all_mentioned_sorns: :environment do
    Sorn.update_all_mentioned_sorns
  end
end

namespace :all_sorns do
  desc "Find new SORNs on the Federal Register API"
  task parse_all_xml_again: :environment do
    Sorn.parse_all_xml_again
  end
end

namespace :bulk do
  desc "Find new SORNs on the Federal Register API"
  task find_sorns: :environment do
    BulkSornParserJob.perform_later(url: 'https://www.govinfo.gov/bulkdata/PAI/2019/PAI-2019-DOD.xml')
    BulkSornParserJob.perform_later(url: 'https://www.govinfo.gov/bulkdata/PAI/2019/PAI-2019-JUSTICE.xml')
  end
end

namespace :repair do
  desc "Find missing names"
  task find_names: :environment do
    sorns_with_missing_names = Sorn.where(system_name: nil).pluck(:id, :xml_url)
    sorns_with_missing_names.each do |id, url|
      sleep 1
      response = HTTParty.get(url, format: :plain)
      return nil unless response.success?
      xml = response.parsed_response
      sorn_parser = SornXmlParser.new(xml)
      parsed_sorn = sorn_parser.parse_sorn
      sorn = Sorn.find(id)
      sorn.update(system_name: parsed_sorn[:system_name])
    end
  end
end

namespace :cf do
  desc "Only run on the first application instance"
  task :on_first_instance do
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    exit(0) unless instance_index == 0
  end
end