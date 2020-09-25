class ParseSornXmlJob < ApplicationJob
  queue_as :default

  def perform(xml_url)
    sleep 1
    puts xml_url
    response = HTTParty.get(xml_url, format: :plain)
    return nil unless response.success?

    xml = response.parsed_response
    sorn_parser = SornXmlParser.new(xml)
    parsed_sorn = sorn_parser.parse_sorn

    parsed_sorn[:xml_url] = xml_url
    agency = Agency.find_or_create_by(name: parsed_sorn[:agency])
    parsed_sorn[:agency_id] = agency.id
    parsed_sorn.delete :agency

    sorn = Sorn.create(parsed_sorn)
    puts "Sorn #{sorn.id} created" if sorn
  end
end
