class ParseSornHtmlJob < ApplicationJob
  queue_as :default

  def perform(html_url)
    puts html_url
    response = HTTParty.get(html_url)
    html = response.parsed_response

    sorn_parser = SornHtmlParser.new(xml)
    puts sorn_parser.get_system_name
  end
end
