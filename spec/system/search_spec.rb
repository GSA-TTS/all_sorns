require "rails_helper"

RSpec.describe "/search", type: :system do
  before do
    driven_by(:selenium_chrome)#_headless)
    11.times { create :sorn }
    create(:sorn, agencies: [create(:agency, name:"Cousin Agency", short_name: "CUZ")])
  end

  it "applies the agency-separator class to the agency pipe separator" do
    visit "/search?search=FAKE"

    expect(page).to have_css '.agency-separator'
  end

  scenario "publication date validation" do
    visit "/search?search=FAKE"

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
    # active date badge should be visible
    expect(page).to have_selector("#active-date-range", count: 1, visible: true)

    # remove dates badge should clear both publication date inputs
    find("#active-date-range").find(".remove-badge").click
    starting_year = find("#starting_year").native.attribute("value")
    ending_year = find("#starting_year").native.attribute("value")
    expect(starting_year).to eq ""
    expect(ending_year).to eq ""

    visit "/search?search=FAKE"
    find("#publication-year-button").click
    # Just a starting year should work
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2019"
    end
    find("#general-search-button").click
    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq ""

    visit "/search?search=FAKE"
    find("#publication-year-button").click
    # Just an ending year should work
    within "#publication-date-fields" do
      fill_in "Ending year", with: "2019"
    end
    find("#general-search-button").click
    # validation message is always on starting year
    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq ""

    # expect clear-all link to remove badge and clear inputs
    find("#publication-year-button").click
    find("#publication-date-fields").find(".clear-all").click
    expect(find("#active-date-range").visible?).to be_falsey
    starting_year = find("#starting_year").native.attribute("value")
    ending_year = find("#starting_year").native.attribute("value")
    expect(starting_year).to eq ""
    expect(ending_year).to eq ""


    visit "/?search=FAKE"
    find("#publication-year-button").click
    within "#publication-date-fields" do
      fill_in "Starting year", with: "1993"
    end
    find("#general-search-button").click

    message = find("#starting_year").native.attribute("validationMessage")
    expect(message).to eq "Sorry, this tool only contains SORNs starting from 1994. Please enter a later starting year"
  end

  scenario "paging doesn't break js" do
    visit "/?search=FAKE"
    find_all("nav.pagination").first.find_all(".page")[1].click
    sleep 1
    # gov banner should remain closed
    expect(find("#gov-banner").visible?).to be_falsey
  end

  # test for fields checkboxes and active filters
  scenario "active-filters" do
    visit "/?search=FAKE"
    click_on 'Sections'
    find('label', text:'Source').click
    find('label', text:'Retrieval').click

    # Click on secitons first to make Agencies button visable above the fold
    click_on 'Sections'
    click_on 'Agencies'
    find('label', text:'Parent Agency').click
    find('label', text:'Child Agency').click

    # active filter badges should be in alphabetical order
    expect(page).to have_selector("#active-fields .active-filter", count: 2, visible: true)
    expect(page).to have_selector("#active-fields:first-child", text: "Retrieval", visible: true)
    expect(page).to have_selector("#active-fields:last-child", text: "Source", visible: true)
    expect(page).to have_selector("#active-agencies .active-filter", count: 2, visible: true)
    expect(page).to have_selector("#active-agencies:first-child", text: "CA", visible: true)
    expect(page).to have_selector("#active-agencies:last-child", text: "PA", visible: true)

    find(".active-filter", text: "Retrieval").find(".remove-badge").click
    # if retrieval is closed, then source is left
    expect(page).to have_selector("#active-fields:first-child", text: "Retrieval", visible: false)
    expect(page).to have_selector("#active-fields:first-child", text: "Source", visible: true)

    # retrieval is closed, it should also be unchecked
    click_on 'Sections'
    expect(find("#fields-retrieval")).not_to be_checked

    # Ensure the deselect all buttons remove the badge headers
    click_on 'Sections'
    click_on 'Agencies'
    find('#agency-deselect-all').click
    expect(find("#active-agencies-filters").visible?).to be_falsey
  end

  scenario "agency search input filters agency list" do
    visit "/?search=FAKE"
    click_on 'Agencies'
    fill_in "agency-search", with: "Parent"
    expect(page).to have_selector '#agencies-parent-agency'
    expect(page).to have_no_selector '#agencies-child-agency'
    expect(page).to have_no_selector '#agencies-cousin-agency'
    expect(page).to have_selector("#agency-filter-help-text", text: "Parent matches 1 agency")

    fill_in "agency-search", with: "agency"
    expect(page).to have_selector("#agency-filter-help-text", text: "agency matches 3 agencies")

    fill_in "agency-search", with: nil
    expect(page).to have_selector("#agency-filter-help-text", text: "")
  end

  scenario "checked, but not visible agencies are still included in the search" do
    visit "/?search=FAKE"
    click_on 'Agencies'
    fill_in "agency-search", with: "Parent"
    find('label', text:'Parent Agency').click
    fill_in "agency-search", with: "Child"
    find('label', text:'Child Agency').click

    find("#general-search-button").click

    expect(page).to have_selector("#active-agencies:last-child", text: "PA", visible: true)
    click_on 'Agencies'
    expect(find("#agencies-parent-agency")).to be_checked
  end

  scenario "agency filtering works with short names" do
    visit "/?search=FAKE"
    click_on 'Agencies'
    fill_in "agency-search", with: "CA"
    expect(page).to have_no_selector '#agencies-parent-agency'
    expect(page).to have_selector '#agencies-child-agency'
  end

  scenario "apply button - add section filter" do
    visit "/?search=FAKE"
    click_on 'Sections'
    find('label', text:'Source').click
    expect(find(".apply-filters").visible?).to be_truthy
  end

  scenario "apply button - add agency filter" do
    visit "/?search=FAKE"
    click_on 'Agencies'
    find('label', text:'Parent Agency').click
    find('label', text:'Child Agency').click
    expect(find(".apply-filters").visible?).to be_truthy
  end

  scenario "apply button - add dates filter" do
    visit "/?search=FAKE"
    find("#publication-year-button").click
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2019"
      fill_in "Ending year", with: "2020"
    end
    expect(find(".apply-filters").visible?).to be_truthy
  end

  scenario "apply button - url with filters" do
    visit "/?search=FAKE&fields%5B%5D=source"
    expect(find(".apply-filters").visible?).to be_falsey
  end

  scenario "apply button - add & remove filters" do
    visit "/?search=FAKE"
    click_on 'Sections'
    find('label', text:'Source').click
    find(".active-filter", text: "Source").find(".remove-badge").click
    expect(find(".apply-filters").visible?).to be_falsey

    find("#publication-year-button").click
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2019"
      fill_in "Ending year", with: "2020"
    end
    find("#active-date-range").find(".remove-badge").click
    expect(find(".apply-filters").visible?).to be_falsey
  end

  scenario "when all filters are gone, filter is hidden" do
    visit "/?search=FAKE"
    click_on 'Sections'
    find('label', text:'Source').click
    find(".active-filter", text: "Source").find(".remove-badge").click

    expect(find("#active-filters").visible?).to be_falsey
  end
end
