FactoryBot.define do
  factory :agency do
    name { "Parent Agency" }
    api_id { 15 }
    parent_api_id { nil }
  end
end
