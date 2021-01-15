RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  after(:create) { |_| FullSornSearch.refresh }
end