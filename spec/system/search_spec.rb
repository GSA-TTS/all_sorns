require "rails_helper"

RSpec.describe "/search", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    create :sorn
  end

  it "default checkboxes are as expected" do
    visit "/search"

    Sorn::DEFAULT_FIELDS.each do |default_field|
      expect(find("#search-#{default_field}")).to be_checked
    end

    expect(find("#search-routine_uses")).not_to be_checked
  end

  it "selected agencies are still checked after a search" do
    visit "/search?agencies[]=Fake+Parent+Agency&fields[]=system_name"

    expect(find("#agency-fake-parent-agency")).to be_checked
  end

  describe "agency filtering" do
    it "agencies selected will stay visible when filtering" do
      visit "/search"

      find("#agencies-button").click # open accordian
      find_field("Fake Parent Agency").find(:xpath, "..").click # click on the parent div
      find("#agencies").fill_in("agency-filter", with: 'child')

      expect(find("#agency-fake-parent-agency")).to be_checked
    end

    it "keeps alphabetical order when filtering" do
      visit "/search"

      find("#agencies-button").click # open accordian
      find_field("Fake Parent Agency").find(:xpath, "..").click # click on the parent div
      find("#agencies").fill_in("agency-filter", with: 'child') # filter
      find_field("Fake Child Agency").find(:xpath, "..").click # click child checkbox
      find("#agencies").fill_in("agency-filter", with: 'child agency') # filter again

      expect(find_all("#selected-agencies label")[0].text).to eq "Fake Child Agency"
      expect(find_all("#selected-agencies label")[1].text).to eq "Fake Parent Agency"
    end
  end
end