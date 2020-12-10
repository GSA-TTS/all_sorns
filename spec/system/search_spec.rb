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
end