FactoryBot.define do
  factory :sorn do
    agency_names { 'Parent Agency | Child Agency' }
    action { "FAKE ACTION" }
    summary { "FAKE SUMMARY" }
    system_name { "FAKE SYSTEM NAME" }
    sequence(:citation) { |n| "FAKE CITATION #{n}" }
    publication_date { "2000-01-13"}
    html_url { "HTML URL" }
    xml_url { "xml_url" }
    xml { nil }
    data_source { 'fedreg' }

    agencies do
      [
        Agency.find_or_create_by(name: "Parent Agency", short_name: "PA"),
        Agency.find_or_create_by(name: "Child Agency", short_name: "CA")
      ]
    end
  end
end