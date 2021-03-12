require "rails_helper"

RSpec.describe "/", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    create :sorn, system_name: "SEARCH FOR THIS"

    visit "/"
    fill_in "general-search", with: "SEARCH FOR THIS"
    find("#general-search-button").click
  end

  context "after search" do
    # logic contained in search.js.erb
    scenario "shows the matching SORN results" do
      expect(page).to have_text 'Displaying 1 for "SEARCH FOR THIS"'
      expect(page).to have_css '.usa-card', count: 1
    end

    scenario "removes the pre-search class" do
      expect(page).to_not have_css '.pre-search'
    end

    scenario "applies style to the agency-separator" do
      expect(page).to have_css '.agency-separator'
    end
  end

  context "publication date behavior" do
    before { find("#publication-year-button").click }

    scenario "gives a starting year validation" do
      within "#publication-date-fields" do
        fill_in "Starting year", with: "2020"
        fill_in "Ending year", with: "2019"
      end
      find("#general-search-button").click # to exit the focus of the cursor

      message = find("#starting_year").native.attribute("validationMessage")
      expect(message).to eq "Starting year should be earlier than the ending year."
    end

    scenario "publication date badges appear, no validation message" do
      within "#publication-date-fields" do
        fill_in "Starting year", with: "2019"
        fill_in "Ending year", with: "2020"
      end
      message = find("#starting_year").native.attribute("validationMessage")
      expect(message).to eq ""
      # active date badge should be visible
      expect(page).to have_selector("#active-date-range", count: 1, visible: true)
    end

    scenario "remove badge button works" do
      within "#publication-date-fields" do
        fill_in "Starting year", with: "2019"
        fill_in "Ending year", with: "2020"
      end
      find("#active-date-range").find(".remove-badge").click
      starting_year = find("#starting_year").native.attribute("value")
      ending_year = find("#starting_year").native.attribute("value")
      expect(starting_year).to eq ""
      expect(ending_year).to eq ""
    end

    scenario "just a starting year works" do
      within "#publication-date-fields" do
        fill_in "Starting year", with: "2019"
      end
      find("#general-search-button").click
      message = find("#starting_year").native.attribute("validationMessage")
      expect(message).to eq ""
      expect(page).to have_selector("#active-date-range", count: 1, visible: true)
    end

    scenario "just ending year works" do
      within "#publication-date-fields" do
        fill_in "Ending year", with: "2019"
      end
      find("#general-search-button").click
      message = find("#starting_year").native.attribute("validationMessage")
      expect(message).to eq ""
      expect(page).to have_selector("#active-date-range", count: 1, visible: true)
    end

    scenario "Clear date filters button removes badges and clears inputs" do
      within "#publication-date-fields" do
        fill_in "Starting year", with: "2019"
        fill_in "Ending year", with: "2020"
      end
      find("#publication-date-fields").find(".clear-all").click
      expect(find("#active-date-range").visible?).to be_falsey
      starting_year = find("#starting_year").native.attribute("value")
      ending_year = find("#starting_year").native.attribute("value")
      expect(starting_year).to eq ""
      expect(ending_year).to eq ""
    end

    scenario "validation for 1994 starting year" do
      within "#publication-date-fields" do
        fill_in "Starting year", with: "1993"
      end
      find("#general-search-button").click
      message = find("#starting_year").native.attribute("validationMessage")
      expect(message).to eq "Sorry, this tool only contains SORNs starting from 1994. Please enter a later starting year"
    end

    context "search results" do
      scenario "only date range matches get returned" do
        create(:sorn, system_name: "SEARCH FOR THIS", publication_date: "2020-07-15")

        within "#publication-date-fields" do
          fill_in "Starting year", with: "2000"
          fill_in "Ending year", with: "2000"
        end
        find("#general-search-button").click
        expect(page).to have_text 'Displaying 1'

        within "#publication-date-fields" do
          fill_in "Starting year", with: "2000"
          fill_in "Ending year", with: "2020"
        end
        find("#general-search-button").click
        expect(page).to have_text 'Displaying all 2'

        within "#publication-date-fields" do
          fill_in "Starting year", with: "2020"
          fill_in "Ending year", with: "2020"
        end
        find("#general-search-button").click
        expect(page).to have_text 'Displaying 1'
      end
    end
  end

  scenario "paging doesn't break js" do
    10.times { create :sorn, system_name: "SEARCH FOR THIS" } # add 10 sorns so paging appears
    find("#general-search-button").click

    sleep 1
    find_all("nav.pagination").first.find_all(".page")[1].click
    # gov banner should remain closed
    expect(find("#gov-banner").visible?).to be_falsey
  end

  context "sections and agencies checkbox behavior" do
    scenario "sections and agencies filters create badges" do
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
    end

    scenario "remove badge buttons works" do
      click_on 'Sections'
      find('label', text:'Source').click
      find('label', text:'Retrieval').click

      find(".active-filter", text: "Retrieval").find(".remove-badge").click
      # if retrieval is closed, then source is left
      expect(page).to have_selector("#active-fields:first-child", text: "Retrieval", visible: false)
      expect(page).to have_selector("#active-fields:first-child", text: "Source", visible: true)

      # retrieval is closed, it should also be unchecked
      expect(find("#fields-retrieval")).not_to be_checked
    end

    scenario "Clear sections filters button works" do
      click_on 'Sections'
      find('label', text:'Source').click
      find('label', text:'Retrieval').click
      find('#fields-deselect-all').click
      expect(find("#active-sections-filters").visible?).to be_falsey
    end

    scenario "Clear agencies filters button works" do
      click_on 'Agencies'
      find('label', text:'Parent Agency').click
      find('#agency-deselect-all').click
      expect(find("#active-agencies-filters").visible?).to be_falsey
    end
  end

  context "Agency filtering" do
    scenario "agency search input filters agency list" do
      click_on 'Agencies'
      fill_in "agency-search", with: "Parent"
      expect(page).to have_selector '#agencies-parent-agency'
      expect(page).to have_no_selector '#agencies-child-agency'
      expect(page).to have_selector("#agency-filter-help-text", text: "Parent matches 1 agency")

      fill_in "agency-search", with: "agency"
      expect(page).to have_selector("#agency-filter-help-text", text: "agency matches 2 agencies")

      fill_in "agency-search", with: nil
      expect(page).to have_selector("#agency-filter-help-text", text: "")
    end

    scenario "checked, but not visible agencies are still included in the search" do
      click_on 'Agencies'
      fill_in "agency-search", with: "Parent"
      find('label', text:'Parent Agency').click
      fill_in "agency-search", with: "Child"
      find('label', text:'Child Agency').click
      expect(page).to have_selector("#active-agencies:last-child", text: "PA", visible: true)
      click_on 'Agencies'
      expect(find("#agencies-parent-agency")).to be_checked
    end

    scenario "agency filtering works with short names" do
      click_on 'Agencies'
      fill_in "agency-search", with: "CA"
      expect(page).to have_no_selector '#agencies-parent-agency'
      expect(page).to have_selector '#agencies-child-agency'
    end

    scenario "hitting enter on the agency name filter doesn't disable the submit buttons and doesn't submit the form" do
      click_on 'Agencies'
      fill_in "agency-search", with: "CA"
      find('#agency-search').native.send_keys(:return)

      expect(page).not_to have_css "#general-search-button[disabled]"
      # If it doesn't submit, then the agency filter section will still be open.
      expect(page).to have_selector "#agency-search", visible: true
    end
  end

  scenario "when all filters are gone, active-filters box is hidden" do
    click_on 'Sections'
    find('label', text:'Source').click
    find(".active-filter", text: "Source").find(".remove-badge").click

    expect(find("#active-filters").visible?).to be_falsey
  end

  context "browse mode" do
    before do
      create :sorn, system_name: "A DIFFERENT NAME"
      visit "/"
    end

    scenario "an empty search lets you browse all SORNs" do
      expect(page).to_not have_css '.usa-card'
      find("#general-search-button").click
      expect(page).to have_css '.usa-card', count: 2
      expect(page).to have_css '.system-name', text: "SEARCH FOR THIS"
      expect(page).to have_css '.system-name', text: "A DIFFERENT NAME"
    end

    scenario "Sections filters are hidden" do
      find("#general-search-button").click
      expect(page).to have_css '.usa-accordion__button', text: "Sections", visible: false
    end
  end

  scenario "csv link building" do
    #  browse mode is bare link
    visit "/"
    find("#general-search-button").click
    expect(page).to have_link href: "search.csv?search=&starting_year=&ending_year="
    # search params
    fill_in "general-search", with: "SEARCH FOR THIS"
    find("#general-search-button").click
    expect(page).to have_link href: "search.csv?search=SEARCH%20FOR%20THIS&starting_year=&ending_year="
    # fields param
    click_on 'Sections'
    find('label', text:'System name').click
    expect(page).to have_link href: "search.csv?search=SEARCH%20FOR%20THIS&fields%5B%5D=system_name&starting_year=&ending_year="
    # agencies param
    click_on 'Agencies'
    find('label', text:'Parent Agency').click
    expect(page).to have_link href: "search.csv?search=SEARCH%20FOR%20THIS&fields%5B%5D=system_name&agencies%5B%5D=Parent%20Agency&starting_year=&ending_year="
    # publication date params
    find("#publication-year-button").click
    within "#publication-date-fields" do
      fill_in "Starting year", with: "2000"
      fill_in "Ending year", with: "2000"
    end
    find("#general-search-button").click
    expect(page).to have_link href: "search.csv?search=SEARCH%20FOR%20THIS&fields%5B%5D=system_name&agencies%5B%5D=Parent%20Agency&starting_year=2000&ending_year=2000"
  end
end
