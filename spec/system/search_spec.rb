require "rails_helper"

RSpec.describe "/search", type: :system do
  before do
    driven_by(:selenium_chrome)
    create :sorn
  end

  it "default checkboxes are as expected" do
    visit "/search"

    Sorn::DEFAULT_FIELDS.each do |default_field|
      expect(find("#search-#{default_field}")).to be_checked
    end

    expect(find("#search-routine_uses")).not_to be_checked
  end

  scenario "publication date searches" do
    visit "/search"

    find("#publication-date-button").click # open accordian
    within "#starting-date" do
      fill_in "Month", with: "01"
      fill_in "Day", with: "13"
      fill_in "Year", with: "2000"
    end
    within "#ending-date" do
      fill_in "Month", with: "01"
      fill_in "Day", with: "13"
      fill_in "Year", with: "2001"
    end

    fill_in "general-search", with: "Hello"
    # find_field("Fake Parent Agency").find(:xpath, "..").click # click on the parent div
    # find("#agencies").fill_in("agency-filter", with: 'child') # filter
    # find_field("Fake Child Agency").find(:xpath, "..").click # click child checkbox
    # find("#agencies").fill_in("agency-filter", with: 'child agency') # filter again

    # expect(find_all("#selected-agencies label")[0].text).to eq "Fake Child Agency"
    # expect(find_all("#selected-agencies label")[1].text).to eq "Fake Parent Agency"
  end
end