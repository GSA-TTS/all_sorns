require 'rails_helper'

RSpec.describe "Search", type: :request do
  let!(:sorn) { create :sorn, citation: "citation" }
  let(:search) { "FAKE" }
  let(:fields) { nil }
  let(:agency) { nil }

  before { get "/?search=#{search}&#{fields}&#{agency}" }

  context "search" do
    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "returns eveything with the default columns" do
      expect(response.body).to include sorn.system_name
      expect(response.body).to include sorn.agencies.first.name
      expect(response.body).to include sorn.action
      expect(response.body).to include sorn.publication_date
      expect(response.body).to include sorn.citation
      expect(response.body).to include sorn.html_url
    end
  end

  context "search with agency select" do
    let(:search) { "FAKE" }
    let(:fields) { 'fields[]=action' }
    let(:agency) { "agencies[]=Parent+Agency" }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class='sorn-attribute-header'>Action</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> ACTION</div>"
    end

    it "agency checkbox is checked" do
      expect(response.body).to include '<input class="usa-checkbox__input" id="agencies-parent-agency" type="checkbox" name="agencies[]" value="Parent Agency" checked>'
    end

    context "agency search with overlapping SORNs" do
      let(:fields) { 'fields[]=system_name' }
      let(:agency) { "agencies[]=Parent+Agency&agencies[]=Child+Agency" }
      let(:child_agency) { create(:agency, name: "Child Agency")}

      before { sorn.agencies << child_agency }

      it "only returns a single SORN, even though it matches the two agencies" do
        expect(response.body).to include "Displaying <b>1</b>  for &quot;FAKE"
        expect(response.body).to include('FAKE SYSTEM NAME')
      end

      it "both agency checkboxed are checked" do
        expect(response.body).to include '<input class="usa-checkbox__input" id="agencies-parent-agency" type="checkbox" name="agencies[]" value="Parent Agency" checked>'
        expect(response.body).to include '<input class="usa-checkbox__input" id="agencies-child-agency" type="checkbox" name="agencies[]" value="Child Agency" checked>'
      end
    end
  end

  context "search with fields selected" do
    let(:search) { "FAKE" }
    let(:fields) { 'fields[]=action' }
    let(:agency) { nil }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class='sorn-attribute-header'>Action</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> ACTION</div>"
    end

    it "field checkbox is checked" do
      expect(response.body).to include '<input class="usa-checkbox__input" id="fields-action" type="checkbox" name="fields[]" value="action" checked>'
    end
  end

  context "multiword search" do
    before do
      create :sorn, categories_of_record: "health record"
      create :sorn, categories_of_record: "health blah blah record"
    end

    let(:search) { "health+record" }
    let(:fields) { "fields[]=categories_of_record" }
    let(:agency) { nil }

    it "returns only exact matches" do
      get "?search=#{search}&#{fields}"

      expect(response.body).to include "Displaying <b>1</b>  for &quot;health record&quot;"
      expect(response.body).to include "<mark>health record</mark>"
      expect(response.body).not_to include "health blah blah record"
    end
  end

  context "publication date search" do
    before { create :sorn, system_name: "NEW SORN", publication_date: "2019-01-13", citation: "different citation", agencies: [create(:agency)] }

    it "only returns the newer sorn in date range" do
      get "/search?search=FAKE&starting_year=2019"

      expect(response.body).to include "NEW SORN" # Newer sorn date
      expect(response.body).to include "2019-01-13" # Newer sorn date
      expect(response.body).not_to include "2000-01-13" # Older sorn date
    end

    it "only returns the older sorn in date range" do
      get "/search?search=FAKE&ending_year=2001"

      expect(response.body).to include "2000-01-13" # Older sorn date
      expect(response.body).not_to include "NEW SORN"
      expect(response.body).not_to include "2019-01-13" # Newer sorn date
    end

    it "ending year is inclusive" do
      get "/search?search=FAKE&ending_year=2000"

      expect(response.body).to include "2000-01-13" # Older sorn date
      expect(response.body).not_to include "NEW SORN"
    end

    it "search works with all params" do
      get "/search?search=different&fields[]=citation&agencies[]=Parent+Agency&starting_year=2019&ending_year=2020"

      expect(response.body).to include "NEW SORN" # Newer sorn date
      expect(response.body).to include "2019-01-13" # Newer sorn date
      expect(response.body).to include "<mark>different</mark>" # Newer citation
    end
  end
end
