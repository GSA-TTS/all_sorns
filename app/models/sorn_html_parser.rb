class SornHtmlParser
  def initialize(html)
    @response = Nokogiri::HTML(html)
  end

  def get_system_name

  end
end