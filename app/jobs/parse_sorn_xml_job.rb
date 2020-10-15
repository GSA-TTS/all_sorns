class ParseSornXmlJob < ApplicationJob
  queue_as :default

  def perform(result)
    sleep 1
    puts result[:xml_url]
    response = HTTParty.get(result[:xml_url], format: :plain)
    return nil unless response.success?

    xml = response.parsed_response
    begin
      puts 'Parsing SORN'
      sorn_parser = SornXmlParser.new(xml)
      parsed_sorn = sorn_parser.parse_sorn
    rescue => e
      puts 'ERROR: ' + e.to_s
    end

    # Add metadata
    parsed_sorn[:xml_url] = result[:xml_url]
    parsed_sorn[:html_url] = result[:html_url]
    parsed_sorn[:citation] = result[:citation]
    agency = Agency.find_or_create_by(name: parsed_sorn[:agency], data_source: :fedreg)
    parsed_sorn[:agency_id] = agency.id
    parsed_sorn.delete :agency
    parsed_sorn[:data_source] = :fedreg

    sorn = Sorn.create(parsed_sorn)
    puts "Sorn #{sorn.id} created" if sorn.id?
  end

    # Update or create
  #   existing_sorn = Sorn.find_by(citation: parsed_sorn[:citation])
  #   if existing_sorn
  #     existing_sorn.assign_attributes(parsed_sorn)
  #     if existing_sorn.changed?
  #       existing_sorn.save
  #       puts "Existing Sorn updated. #{existing_sorn.id}"
  #     end
  #   else
  #     new_sorn = Sorn.create(parsed_sorn)
  #     if new_sorn
  #       puts "Sorn #{new_sorn.id} created"
  #     else
  #       puts "No new Sorn created for some reason. #{parsed_sorn[:xml_url]}"
  #     end
  #   end
  # end
end
