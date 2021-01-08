require 'rails_helper'

RSpec.describe "Search csv", type: :request do

  before do
    create :sorn
    FullSornSearch.refresh # refresh the materialized view
    get "/search.csv?search=#{search}&#{fields}&#{agency}"
  end

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
    let(:search) { "FAKE" }
    let(:fields) { "fields[]=action" }
    let(:agency) { nil }

    it "returns matching, with only selected columns" do
      expect(response.body).to eq "action\nFAKE ACTION\n"
    end
  end

  context "with agency search" do
    let(:search) { "FAKE" }
    let(:fields) { nil }
    let(:agency) { "agencies[]=Parent+Agency&agencies[]=Child+Agency" }

    it "returns sorns filtered by agency, no duplicates" do
      expect(response.body).to include("Parent Agency | Child Agency,FAKE ACTION,FAKE SUMMARY,,,,,FAKE SYSTEM NAME,,,,,,,,,,,,,,,,,,,").once
    end
  end
end
