require 'rails_helper'

RSpec.describe "Search", type: :request do
  let!(:sorn) { create :sorn }

  before { get "/search?search=#{search}&#{fields}&#{agency}" }

  context "/search" do
    let(:search) { nil }
    let(:fields) { nil }
    let(:agency) { nil }

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

    it "no search result summaries" do
      expect(response.body).not_to include 'FOUND IN'
    end
  end

  context "search with agency select" do
    let(:search) { "FAKE" }
    let(:fields) { 'fields[]=action' }
    let(:agency) { "agency=FAKE+AGENCIES" }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "agencies accordian is open" do
      expect(response.body).to include '<button class="usa-accordion__button" aria-expanded="true" aria-controls="a1" type="button">Agencies</button>'
    end

    it "default agency set" do
      expect(response.body).to include 'data-default-value="FAKE AGENCIES"'
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class='sorn-attribute-header'>Action</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> ACTION</div>"
    end
  end

  context "search without agency select" do
    let(:search) { "FAKE" }
    let(:fields) { 'fields[]=action' }
    let(:agency) { nil }


    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "agencies accordian is closed" do
      expect(response.body).to include '<button class="usa-accordion__button" aria-expanded="false" aria-controls="a1" type="button">Agencies</button>'
    end

    it "no default agency selected" do
      expect(response.body).to include 'data-default-value=""'
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class='sorn-attribute-header'>Action</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> ACTION</div>"
    end
  end

  context "search with default columns" do
    let(:search) { "FAKE" }
    let(:fields) { "fields%5B%5D=agency_names&fields%5B%5D=action&fields%5B%5D=summary&fields%5B%5D=system_name&fields%5B%5D=html_url&fields%5B%5D=publication_date" }
    let(:agency) { nil }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "returns found results with default columns" do
      # default fields
      expect(response.body).to include "FAKE SYSTEM NAME"
      expect(response.body).to include 'FAKE AGENCIES'
      expect(response.body).to include "HTML URL"
      expect(response.body).to include "2000-01-13"
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class='sorn-attribute-header'>Agency names</div>"
      expect(response.body).to include "<div class='found-section-snippet'>[\"<mark>FAKE</mark> AGENCY NAMES\"]</div>"
      expect(response.body).to include "<div class='sorn-attribute-header'>Action</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> ACTION</div>"
      expect(response.body).to include "<div class='sorn-attribute-header'>Summary</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> SUMMARY</div>"
      expect(response.body).to include "<div class='sorn-attribute-header'>System name</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>FAKE</mark> SYSTEM NAME</div>"
    end
  end

  context "search with different columns" do
    let(:search) { "citation" }
    let(:fields) { "fields%5B%5D=citation" }
    let(:agency) { nil }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end

    it "with search result summaries" do
      expect(response.body).to include 'FOUND IN'
      expect(response.body).to include "<div class='sorn-attribute-header'>Citation</div>"
      expect(response.body).to include "<div class='found-section-snippet'><mark>citation</mark></div>"
    end
  end

  context "blank search, with different columns" do
    let(:search) { nil }
    let(:fields) { "fields%5B%5D=citation" }
    let(:agency) { nil }

    it "succeeds" do
      expect(response.successful?).to be_truthy
    end
  end
end
