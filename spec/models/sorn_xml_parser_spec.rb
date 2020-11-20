require 'rails_helper'

RSpec.describe SornXmlParser, type: :model do
  let(:sorn) do
    xml = file_fixture("sorn.xml").read
    create(:sorn, xml: xml)
  end

  let(:parser) do
    xml = file_fixture("sorn.xml").read
    SornXmlParser.new(xml)
  end

  describe ".get_system_number" do
    context "A system name" do
      
      it "return nil when no number" do
        system_name = ["National Docketing Management Information System (NDMIS)"]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq nil
      end

      it "returns a number only name" do
        system_name = ["Family Advocacy Program Record.	2003-11-18"]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq "2003-11-18"
      end

      it "returns a parenthetical name" do
        system_name = ["Criminal Investigations (11VA51)."]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq "11VA51"
      end

      it "return has a . in it" do
        system_name = ["CFPB.009—Employee Administrative Records System."]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq "CFPB.009"
      end

      it "return has a . in it" do
        system_name = ["CFPB.009—Employee Administrative Records System."]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq "CFPB.009"
      end

      it "uses the stock xml field return has two names in the systmem name in it" do
        parser.get_system_name 
        expect(parser.get_system_number).to eq "GSA/OGP-1"
      end

    end

    context "Has an excluded regex capture" do

      it "excludes the cfr and date reference" do
      # find potential capture groups
        system_name = ["Database of Reserve/Retired Judge Advocates and Legalmen (July 14, 1999, 64 FR 37944)."]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq nil
      end

      it "excludes the HSPD-12 references" do
        system_name = ["HSPD-12: Identity Management, Personnel Security, Physical and Logical Access Files."]
        allow(parser).to receive(:find_section).and_return(system_name)
        parser.get_system_name
        expect(parser.get_system_number).to eq nil
      end
    end
  end

  xdescribe ".parse_xml" do
    it "returns the expected hash" do
      parsed_xml = SornXmlParser.new(sorn.xml).parse_xml

      expect(parsed_xml[:action]).to eq "Notice of a new system of records."

      expected_summary = ["GSA is publishing this system of records notice (SORN) as the new managing partner of the e-Rulemaking Program, effective October 1, 2019. The e-Rulemaking Program includes the Federal Docket Management System (FDMS) and","Regulations.gov. Regulations.gov",       "allows the public to search, view, download, and comment on Federal agencies\' rulemaking documents in one central location on-line. FDMS provides each participating Federal agency with the ability to electronically access and manage its own rulemaking dockets, or other dockets, including comments or supporting materials submitted by individuals or organizations. GSA is establishing the GSA/OGP-1, e-Rulemaking Program Administrative System to manage","regulations.gov","and partner agency access to the Federal Docket Management System (FDMS)."]
      expect(parsed_xml[:summary]).to eq expected_summary

      expect(parsed_xml[:system_name]).to "GSA/OGP-1, e-Rulemaking Program Administrative System."

      # summary: get_summary,
      # dates: get_dates,
      # addresses: get_addresses,
      # further_info: get_further_information,
      # supplementary_info: get_supplementary_information,
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