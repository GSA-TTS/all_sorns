class ParseSornXmlJob < ApplicationJob
  queue_as :default

  def perform(sorn_id)
    sleep 1

    sorn = Sorn.find(sorn_id)
    puts sorn.xml_url
    sorn.get_xml if sorn.xml_url.present? and sorn.xml.blank?
    sorn.parse_xml if sorn.xml.present?
    puts "Updated #{sorn.id}"
  end
end
