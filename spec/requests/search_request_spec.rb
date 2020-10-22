require 'rails_helper'

RSpec.describe "Search", type: :request do
  let!(:sorn) { create :sorn }

  before { get "/search?search=#{search}&#{fields}" }

  context "/search" do
    let(:search) { nil }
    let(:fields) { nil }

    it "returns eveything with the default columns" do
      # default fields
      Sorn::DEFAULT_FIELDS.each do |default_field|
        expect(response.body).to include sorn.send(default_field)
      end
    end

    it "csv link matches" do
      expect(response.body).to include '<a href="/search.csv?search=">'
    end
  end


  context "search with default columns" do
    let(:search) { "FAKE" }
    let(:fields) { "fields%5B%5D=agency_names&fields%5B%5D=action&fields%5B%5D=summary&fields%5B%5D=system_name&fields%5B%5D=html_url&fields%5B%5D=publication_date" }

    it "returns found results with default columns" do
      # default fields
      expect(response.body).to include '["<mark>FAKE</mark> AGENCY"]'
      expect(response.body).to include "<mark>FAKE</mark> ACTION"
      expect(response.body).to include "<mark>FAKE</mark> SUMMARY"
      expect(response.body).to include "<mark>FAKE</mark> SYSTEM NAME"
      expect(response.body).to include "HTML URL"
      expect(response.body).to include "2000-01-13"
    end

    it "csv link matches" do
      expect(response.body).to include "<a href=\"/search.csv?#{fields}&search=#{search}\">"
    end
  end

  context "search with different columns" do
    let(:search) { "citation" }
    let(:fields) { "fields%5B%5D=citation" }

    it "returns matching, with only selected columns" do
      expect(response.body).to include '<mark>citation</mark>'
      expect(response.body).to_not include "FAKE SYSTEM NAME"
    end

    it "csv link matches" do
      expect(response.body).to include "<a href=\"/search.csv?#{fields}&search=#{search}\">"
    end
  end

  context "blank search, with different columns" do
    let(:search) { nil }
    let(:fields) { "fields%5B%5D=citation" }

    it "returns everything, with only selected columns" do
      expect(response.body).to include 'citation'
      expect(response.body).to_not include "FAKE SYSTEM NAME"
    end

    it "csv link matches" do
      expect(response.body).to include "<a href=\"/search.csv?#{fields}&search=#{search}\">"
    end
  end
end
