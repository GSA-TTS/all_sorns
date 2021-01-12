require 'rails_helper'

RSpec.describe "Search csv", type: :request do
  let!(:sorn) { create :sorn, citation: "citation" }

  before { get "/search.csv?search=#{search}&#{fields}&#{agency}" }

  context "/search" do
    let(:search) { "FAKE" }
    let(:fields) { nil }
    let(:agency) { nil }

     it "returns eveything with all columns" do
      all_columns = "agency_names,action,summary,dates,addresses,further_info,supplementary_info,system_name,system_number,security,location,manager,authority,purpose,categories_of_individuals,categories_of_record,source,routine_uses,storage,retrieval,retention,safeguards,access,contesting,notification,exemptions,history"
      result = "Parent Agency | Child Agency,FAKE ACTION,FAKE SUMMARY,,,,,FAKE SYSTEM NAME,,,,,,,,,,,,,,,,,,,"
      expect(response.body).to include all_columns
      expect(response.body).to include result
    end
  end

  context "search with different columns" do
    let(:search) { "citation" }
    let(:fields) { "fields%5B%5D=citation" }
    let(:agency) { nil }

    it "returns matching, with only selected columns" do
      expect(response.body).to eq "citation\ncitation\n"
    end
  end

  context "with agency search" do
    let(:search) { "FAKE" }
    let(:fields) { "fields%5B%5D=agency_names&fields%5B%5D=action&fields%5B%5D=system_name&fields%5B%5D=summary&fields%5B%5D=html_url&fields%5B%5D=publication_date" }
    let(:agency) { "agencies[]=Parent+Agency&agencies[]=Child+Agency" }

    it "returns sorns filtered by agency, no duplicates" do
      expect(response.body).to include("Parent Agency | Child Agency,FAKE ACTION,FAKE SYSTEM NAME,FAKE SUMMARY,HTML URL,2000-01-13").once
    end
  end
end
