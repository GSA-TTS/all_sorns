class ParseSornXmlJob < ApplicationJob
  queue_as :default

  def perform(xml_url)
    sleep 1
    puts xml_url
    response = HTTParty.get(xml_url, format: :plain)
    xml = response.parsed_response

    sorn_parser = SornXmlParser.new(xml)
    parsed_sorn = sorn_parser.parse_sorn
    parsed_sorn[:xml_url] = xml_url
    agency_name = parsed_sorn[:agency]
    agency = Agency.find_or_create_by(name: agency_name)
    parsed_sorn[:agency_id] = agency.id
    parsed_sorn[:a108] = parsed_sorn.values.all?
    puts parsed_sorn
    parsed_sorn.delete :agency
    Sorn.create(parsed_sorn)
    puts "Sorn #{sorn.id} created"
  end
end
