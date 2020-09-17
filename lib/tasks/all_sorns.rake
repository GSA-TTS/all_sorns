namespace :all_sorns do
  desc "Find new SORNs on the Federal Register API"
  task find_new_sorns: :environment do
    FindSornsJob.perform_now
  end

  desc "Parse new GSA SORN, A108 compliant"
  task :local_gsa_sorn, [:xml_url] => [:environment] do |t, args|

    response = HTTParty.get(args[:xml_url], format: :plain)
    xml = response.parsed_response
    sorn_parser = SornXmlParser.new(xml)
    parsed_sorn = sorn_parser.parse_sorn
    puts parsed_sorn
    # agency_name = parsed_sorn[:agency]
    # agency = Agency.find_or_create_by(name: agency_name)
    # parsed_sorn[:agency_id] = agency.id
    # parsed_sorn.delete :agency
    # parsed_sorn[:a108] = parsed_sorn.values.all?
    # Sorn.create(parsed_sorn)
  end
end
