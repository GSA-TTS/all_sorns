# This will guess the User class
FactoryBot.define do
  factory :sorn do
    citation { 'citation' }
    xml_url { "xml_url" }
    xml { nil }
    data_source { :fedreg }
  end
end