require 'rails_helper'

RSpec.describe "Search csv", type: :request do
  let!(:sorn) { create :sorn }

  before { get "/search.csv?search=#{search}&#{fields}&#{agency}" }

  context "/search" do
    let(:search) { nil }
    let(:fields) { nil }
    let(:agency) { nil }

    it "returns eveything with the default columns" do
      expect(response.body).to eq "agency_names,action,system_name,summary,html_url,publication_date\n\"[\"\"FAKE AGENCY NAMES\"\"]\",FAKE ACTION,FAKE SYSTEM NAME,FAKE SUMMARY,HTML URL,2000-01-13\n"
    end
  end

  context "search with default columns" do
    let(:search) { "FAKE" }
    let(:fields) { "fields%5B%5D=agency_names&fields%5B%5D=action&fields%5B%5D=system_name&fields%5B%5D=summary&fields%5B%5D=html_url&fields%5B%5D=publication_date" }
    let(:agency) { nil }

    it "returns found results with default columns" do
      expect(response.body).to eq "agency_names,action,system_name,summary,html_url,publication_date\n\"[\"\"FAKE AGENCY NAMES\"\"]\",FAKE ACTION,FAKE SYSTEM NAME,FAKE SUMMARY,HTML URL,2000-01-13\n"
    end
  end

  context "search with different columns and agency select" do
    let(:search) { "citation" }
    let(:fields) { "fields%5B%5D=citation" }
    let(:agency) { nil }

    it "returns matching, with only selected columns" do
      expect(response.body).to eq "citation\ncitation\n"
    end
  end

  context "blank search, with different columns" do
    let(:search) { nil }
    let(:fields) { "fields%5B%5D=citation" }
    let(:agency) { nil }

    it "returns everything, with only selected columns" do
      expect(response.body).to eq "citation\ncitation\n"
    end
  end

  xcontext "agency select doesn't work yet" do
    let(:search) { nil }
    let(:fields) { "fields%5B%5D=citation" }
    let(:agency) { "FAKE AGENCIES" }

    it "returns agency sorns, with only selected columns. What to use in the csv for the agencies names though?" do
    end
  end

end
