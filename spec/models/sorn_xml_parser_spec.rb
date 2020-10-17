require 'rails_helper'

RSpec.describe SornXmlParser, type: :model do
  let(:sorn) do
    xml = file_fixture("sorn.xml").read
    create(:sorn, xml: xml)
  end

  xdescribe ".parse_xml" do
    it "returns the expected hash" do
      parsed_xml = SornXmlParser.new(sorn.xml).parse_xml

      expect(parsed_xml[:action]).to eq "Notice of a new system of records."

      expected_summary = ["GSA is publishing this system of records notice (SORN) as the new managing partner of the e-Rulemaking Program, effective October 1, 2019. The e-Rulemaking Program includes the Federal Docket Management System (FDMS) and","Regulations.gov. Regulations.gov",       "allows the public to search, view, download, and comment on Federal agencies\' rulemaking documents in one central location on-line. FDMS provides each participating Federal agency with the ability to electronically access and manage its own rulemaking dockets, or other dockets, including comments or supporting materials submitted by individuals or organizations. GSA is establishing the GSA/OGP-1, e-Rulemaking Program Administrative System to manage","regulations.gov","and partner agency access to the Federal Docket Management System (FDMS)."]
      expect(parsed_xml[:summary]).to eq expected_summary

      # summary: get_summary,
      # dates: get_dates,
      # addresses: get_addresses,
      # further_info: get_further_information,
      # supplementary_info: get_supplementary_information,
      # system_name: get_system_name,
      # system_number: get_system_number,
      # security: get_security,
      # location: get_location,
      # manager: get_manager,
      # authority: get_authority,
      # purpose: get_purpose,
      # categories_of_individuals: get_individuals,
      # categories_of_record: get_categories_of_record,
      # source: get_source,
      # routine_uses: get_routine_uses,
      # storage: get_storage,
      # retrieval: get_retrieval,
      # retention: get_retention,
      # safeguards: get_safeguards,
      # access: get_access,
      # contesting: get_contesting,
      # notification: get_notification,
      # exemptions: get_exemptions,
      # history: get_history,
      # headers: @sections.keys
    end
  end
end