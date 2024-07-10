# federal_register depends on URI.encode which was removed in Ruby 3.0 :sob:
module URI
  def self.encode(value)
    CGI.escape(value)
  end
end
