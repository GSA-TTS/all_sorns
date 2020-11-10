class ParseSornXmlJob < ApplicationJob
  queue_as :default

  def perform(sorn_id)
    sleep 1

    sorn = Sorn.find(sorn_id)
    puts sorn.xml_url
    sorn.get_xml
    sorn.parse_xml
    sorn.get_mentioned_sorns
    puts "Updated #{sorn.id}"
  end
end
