# This will guess the User class
FactoryBot.define do
  factory :sorn do
    agency_names { 'Fake Parent Agency | Fake Child Agency' }
    action { "FAKE ACTION" }
    summary { "FAKE SUMMARY" }
    system_name { "FAKE SYSTEM NAME" }
    sequence(:citation) { |n| "FAKE CITATION #{n}" }
    publication_date { "2000-01-13"}
    html_url { "HTML URL" }
    xml_url { "xml_url" }
    xml { nil }
    data_source { 'fedreg' }
    agencies { [ association(:agency),  association(:agency, name: "Fake Child Agency")] }
  end
end