require "rails_helper"

RSpec.describe "/search", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    create :sorn
  end

  it "default checkboxes are as expected" do
    visit "/search"

    expect(find("#search-agency_names")).to be_checked
    expect(find("#search-action")).to be_checked
    expect(find("#search-system_name")).to be_checked
    expect(find("#search-authority")).to be_checked
    expect(find("#search-categories_of_record")).to be_checked

    expect(find("#search-summary")).not_to be_checked
  end
end