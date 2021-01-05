require "rails_helper"

RSpec.describe "/search", type: :system do
  before do
    driven_by(:selenium_chrome)
    11.times { create :sorn }
  end

<<<<<<< HEAD
  it "selected agencies are still checked after a search" do
    visit "/search?search=fakeagencies[]=Parent+Agency&fields[]=system_name"
    expect(find("#agencies-parent-agency")).to be_checked
  end

  it "applies the agency-separator class to the agency pipe separator" do
    visit "/search?search=fake"
=======
  it "applies the agency-separator class to the agency pipe separator" do
    visit "/search?search=FAKE"

>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864
    expect(page).to have_css '.agency-separator'
  end

  scenario "publication date validation" do
<<<<<<< HEAD
    visit "/search?search=fake"
=======
    visit "/search?search=FAKE"
>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864

    find("#publication-year-button").click
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2020"
      fill_in "Ending year", with: "2019"

    end
    find("#general-search-button").click

    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq "Starting year should be earlier than the ending year."

    # Fix the years and submit should work
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2019"
      fill_in "Ending year", with: "2020"
    end
    find("#general-search-button").click
    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq ""

<<<<<<< HEAD
    visit "/search?search=fake"
=======
    visit "/search?search=FAKE"
>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864
    find("#publication-year-button").click
    # Just a starting year should work
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2019"
    end
    find("#general-search-button").click
    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq ""

<<<<<<< HEAD
    visit "/search?search=fake"
=======
    visit "/search?search=FAKE"
>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864
    find("#publication-year-button").click
    # Just an ending year should work
    within "#publication-date-fields" do
      fill_in "Ending year", with: "2019"
    end
    find("#general-search-button").click
    # validation message is always on starting year
    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq ""

<<<<<<< HEAD
    visit "/search?search=fake"
=======
    visit "/?search=FAKE"
>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864
    find("#publication-year-button").click
    within "#publication-date-fields" do
      fill_in "Starting year", with: "1993"
    end
    find("#general-search-button").click

    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq "Sorry, this tool only contains SORNs starting from 1994. Please enter a later starting year"
  end

  scenario "paging doesn't break js" do
<<<<<<< HEAD
    visit "/search?search=fake"
=======
    visit "/?search=FAKE"
>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864
    find_all("nav.pagination").first.find_all(".page")[1].click
    sleep 1
    # gov banner should remain closed
    expect(find("#gov-banner").visible?).to be_falsey
  end
end