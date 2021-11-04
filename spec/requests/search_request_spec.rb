require "rails_helper"

RSpec.describe "Search", type: :request do
  let!(:sorn) { create :sorn }
  let(:search) { "FAKE" }
  let(:fields) { nil }
  let(:agency) { nil }

  before do
    get search_path, params: {search: search, fields: fields, agencies: agency}, xhr: true
  end

  context "search" do
    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "returns eveything expected on the card" do
      expect(response.body).to include sorn.system_name
      expect(response.body).to include sorn.agencies.first.name
      expect(response.body).to include sorn.action
      expect(response.body).to include sorn.publication_date
      expect(response.body).to include sorn.citation
      expect(response.body).to include sorn.html_url
    end
  end

  context "multiword search" do
    let(:search) { "FAKE SYSTEM NAME" }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "returns eveything expected on the card" do
      expect(response.body).to include sorn.system_name
      expect(response.body).to include sorn.agencies.first.name
      expect(response.body).to include sorn.action
      expect(response.body).to include sorn.publication_date
      expect(response.body).to include sorn.citation
      expect(response.body).to include sorn.html_url
    end
  end

  context "search with agency select" do
    let(:agency) { "Parent Agency" }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "had correct agency" do
      expect(response.body).to include '<span class=\\"agency-names\\">Parent Agency | Child Agency<\\/span>'
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class=\\'sorn-attribute-header\\'>Action<\\/div>"
      expect(response.body).to include "<div class=\\'found-section-snippet\\'><mark>FAKE<\\/mark> ACTION<\\/div>"
    end

    context "agency search with overlapping SORNs" do
      let(:fields) { ['system_name'] }
      let(:agency) { ['Parent Agency', 'Child Agency'] }

      it "only returns a single SORN, even though it matches the two agencies" do
        expect(response.body).to include "Displaying <b>1<\\/b>  for &quot;FAKE"
        expect(response.body).to include('FAKE SYSTEM NAME').once
      end
    end
  end

  context "search with fields selected" do
    let(:search) { "FAKE" }
    let(:fields) { ['action'] }
    let(:agency) { nil }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class=\\'sorn-attribute-header\\'>Action<\\/div>"
      expect(response.body).to include "<div class=\\'found-section-snippet\\'><mark>FAKE<\\/mark> ACTION<\\/div>"
    end
  end

  context "multiword search" do
    before do
      create :sorn, categories_of_record: "health record", xml: "health record"
      create :sorn, categories_of_record: "health blah blah record", xml: "health blah blah record"
    end

    let(:search) { "health+record" }
    let(:fields) { ['categories_of_record'] }
    let(:agency) { nil }

    it "returns only exact matches" do
      get "/search?search=#{search}&#{fields}", xhr: true

      expect(response.body).to include "Displaying <b>1<\\/b>  for &quot;health record&quot;"
      expect(response.body).to include "<mark>health record<\\/mark>"
      expect(response.body).not_to include "blah blah"
    end
  end

  context "publication date search" do
    before do
      create :sorn, system_name: "NEW SORN", publication_date: "2019-01-13", citation: "different citation", agencies: [create(:agency)]
    end

    it "only returns the newer sorn in date range" do
      get search_path, params: {search: "FAKE", starting_year: "2019"}, xhr: true

      expect(response.body).to include "NEW SORN" # Newer sorn date
      expect(response.body).to include "2019-01-13" # Newer sorn date
      expect(response.body).not_to include "2000-01-13" # Older sorn date
    end

    it "only returns the older sorn in date range" do
      get search_path, params: {search: "FAKE", ending_year: "2001"}, xhr: true

      expect(response.body).to include "2000-01-13" # Older sorn date
      expect(response.body).not_to include "NEW SORN"
      expect(response.body).not_to include "2019-01-13" # Newer sorn date
    end

    it "ending year is inclusive" do
      get search_path, params: {search: "FAKE", ending_year: "2000"}, xhr: true

      expect(response.body).to include "2000-01-13" # Older sorn date
      expect(response.body).not_to include "NEW SORN"
    end

    it "search works with all params" do
      get search_path, params: {search: "FAKE", fields: ['action'], agency: "Parent Agency", starting_year: "2019", ending_year: "2020"}, xhr: true

      expect(response.body).to include "NEW SORN" # Newer sorn date
      expect(response.body).to include "2019-01-13" # Newer sorn date
      expect(response.body).to include "<mark>FAKE<\\/mark> ACTION" # Newer citation
    end
  end

  context "including beforeSearch.js pack" do
    it "included on main search page" do
      get "/"
      expect(response.body).to include '/packs-test/js/beforeSearch-'
    end

    it "not on the about page" do
      get "/about"
      expect(response.body).to_not include '/packs-test/js/beforeSearch-'
    end
  end

  context 'when sent invalid characters' do
    context 'in string params' do
      it 'raises bad request exception' do
        expect do
          get search_path, params: { search: "\u0000" }, xhr: true
        end.to raise_error(ActionController::BadRequest)
      end
    end

    context 'in array params' do
      it 'raises bad request exception' do
        expect do
          get search_path, params: { agencies: ["\u0000", "abcdef"] }, xhr: true
        end.to raise_error(ActionController::BadRequest)
      end
    end
  end
end
