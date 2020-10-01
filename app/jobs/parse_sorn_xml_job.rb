class ParseSornXmlJob < ApplicationJob
  queue_as :default

  def perform(xml_url, html_url)
    sleep 1
    puts xml_url
    response = HTTParty.get(xml_url, format: :plain)
    return nil unless response.success?

    xml = response.parsed_response
    sorn_parser = SornXmlParser.new(xml)
    parsed_sorn = sorn_parser.parse_sorn

    parsed_sorn[:xml_url] = xml_url
    parsed_sorn[:html_url] = html_url
    agency = Agency.find_or_create_by(name: parsed_sorn[:agency], data_source: :fedreg)
    parsed_sorn[:agency_id] = agency.id
    parsed_sorn.delete :agency

    parsed_sorn[:data_source] = :fedreg
    sorn = Sorn.create(parsed_sorn)
    puts "Sorn #{sorn.id} created" if sorn
  end
end
