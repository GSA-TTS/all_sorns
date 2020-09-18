class CssParser
  def self.parse
    response = HTTParty.get(xml_url, format: :plain)
    xml = response.parsed_response
    doc = Nokogiri::XML(xml)
    doc.css('PRIACT HD:contains("SYSTEM NAME")')
    # doc.xpath('//PRIACT/HD[contains(text(), "SYSTEM NAME")]')
    doc.xpath('//P[preceding-sibling::HD[contains(text(), "SYSTEM NAME")] and following-sibling::HD[contains(text(), "SECURITY")]]')
  end
end