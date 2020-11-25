require 'rails_helper'

RSpec.describe SornXmlParser, type: :model do
  let(:xml) { file_fixture("sorn.xml").read }
  let(:parser) do
    SornXmlParser.new(xml)
  end

  describe ".find_tag" do
    context "a complicated array summary, in sorn.xml" do
      it "returns the cleaned up as a string" do
        expect(parser.find_tag("SUM")).to eq "GSA is publishing this system of records notice (SORN) as the new managing partner of the e-Rulemaking Program, effective October 1, 2019. The e-Rulemaking Program includes the Federal Docket Management System (FDMS) and Regulations.gov. Regulations.gov allows the public to search, view, download, and comment on Federal agencies' rulemaking documents in one central location on-line. FDMS provides each participating Federal agency with the ability to electronically access and manage its own rulemaking dockets, or other dockets, including comments or supporting materials submitted by individuals or organizations. GSA is establishing the GSA/OGP-1, e-Rulemaking Program Administrative System to manage regulations.gov and partner agency access to the Federal Docket Management System (FDMS)."
      end
    end

    context "another array" do
      let(:xml) do
        <<~HEREDOC
          <SUM>
            <HD SOURCE="HED">SUMMARY:</HD>
            <P>
              In accordance with the Privacy Act of 1974, the Department of Homeland Security (DHS) proposes to modify and reissue a current DHS system of records titled, “DHS/United States Coast Guard (USCG)-061 Maritime Awareness Global Network (MAGNET) System of Records.” The modified system of records is to be reissued and renamed as “DHS/USCG-061 Maritime Analytic Support System (MASS) System of Records.” This system of records allows the DHS/USCG to collect and maintain records in a centralized location that relate to the U.S. Coast Guard's missions that are found within the maritime domain. The information covered by this system of records is relevant to the eleven U.S. Coast Guard statutory missions (Port, Waterways, and Coastal Security (PWCS); Drug Interdiction; Aid to Maritime Navigation; Search and Rescue (SAR) Operations; Protection of Living Marine Resources; Ensuring Marine Safety, Defense Readiness; Migrant Interdiction; Marine Environmental Protection; Ice Operations; and Law Enforcement). DHS/USCG is updating this system of records notice to include and update additional data sources, system security and auditing protocols, routine uses, and user interfaces. Additionally, DHS/USCG is concurrently issuing a Notice of Proposed Rulemaking, and subsequent Final Rule, to exempt this system of records from certain provisions of the Privacy Act due to criminal, civil, and administrative enforcement requirements. Furthermore, this notice includes non-substantive changes to simplify the formatting and text of the previously published notice.
              <PRTPAGE P="74743"/>
            </P>
            <P>This modified system will be included in DHS's inventory of record systems.</P>
          </SUM>
        HEREDOC
      end

      it "returns the cleaned content" do
        expect(parser.find_tag("SUM")).to eq "In accordance with the Privacy Act of 1974, the Department of Homeland Security (DHS) proposes to modify and reissue a current DHS system of records titled, “DHS/United States Coast Guard (USCG)-061 Maritime Awareness Global Network (MAGNET) System of Records.” The modified system of records is to be reissued and renamed as “DHS/USCG-061 Maritime Analytic Support System (MASS) System of Records.” This system of records allows the DHS/USCG to collect and maintain records in a centralized location that relate to the U.S. Coast Guard's missions that are found within the maritime domain. The information covered by this system of records is relevant to the eleven U.S. Coast Guard statutory missions (Port, Waterways, and Coastal Security (PWCS); Drug Interdiction; Aid to Maritime Navigation; Search and Rescue (SAR) Operations; Protection of Living Marine Resources; Ensuring Marine Safety, Defense Readiness; Migrant Interdiction; Marine Environmental Protection; Ice Operations; and Law Enforcement). DHS/USCG is updating this system of records notice to include and update additional data sources, system security and auditing protocols, routine uses, and user interfaces. Additionally, DHS/USCG is concurrently issuing a Notice of Proposed Rulemaking, and subsequent Final Rule, to exempt this system of records from certain provisions of the Privacy Act due to criminal, civil, and administrative enforcement requirements. Furthermore, this notice includes non-substantive changes to simplify the formatting and text of the previously published notice.  This modified system will be included in DHS's inventory of record systems."
      end
    end

    context "an even wilder array" do
      let(:xml) do
        <<~HEREDOC
        <ADD>
        <PRTPAGE P="75030"/>
        <HD SOURCE="HED">ADDRESSES:</HD>
        <P>You may submit comments identified by docket number [DOI-2020-0004] by any of the following methods:</P>
        <P>
        •
        <E T="03">Federal eRulemaking Portal:</E>
        <E T="03">http://www.regulations.gov.</E>
        Follow the instructions for sending comments.
        </P>
        </ADD>
        HEREDOC
      end

      it "returns the cleaned content" do
        expect(parser.find_tag("ADD")).to eq "You may submit comments identified by docket number [DOI-2020-0004] by any of the following methods: • Federal eRulemaking Portal: http://www.regulations.gov. Follow the instructions for sending comments."
      end
    end

    context "a single P summary" do
      let(:xml) do
        <<~HEREDOC
        <SUM>
          <HD SOURCE="HED">SUMMARY:</HD>
          <P>In accordance with the requirements of the Privacy Act of 1974, as amended, the Department is publishing its modified Privacy Act systems of record.</P>
        </SUM>
        HEREDOC
      end

      it "returns the cleaned content" do
        expect(parser.find_tag("SUM")).to eq "In accordance with the requirements of the Privacy Act of 1974, as amended, the Department is publishing its modified Privacy Act systems of record."
      end
    end
  end

  describe ".get_supplementary_information" do
    it "returns clean string" do
      expected_content = "The e-Rulemaking Program has been managed by the Environmental Protection Agency (EPA). However, based on direction from the Office of Management and Budget (OMB), GSA will be the managing partner of the Program, effective October 1, 2019. GSA is assuming the role of managing partner and is establishing this system of records to support GSA's management of regulations.gov and partner agency access to FDMS. This notice describes how GSA, as managing partner, manages partner agencies' users' credentials. This system of records does not include records pertaining to agency rulemakings ( e.g., comments received); partner agencies are responsible for any Privacy Act Notices relevant to their rulemaking materials."
      expect(parser.get_supplementary_information).to eq expected_content
    end

    context "wild example" do
      let(:xml) do
        <<~HEREDOC
        <SUPLINF>
        <HD SOURCE="HED">SUPPLEMENTARY INFORMATION:</HD>
        <HD SOURCE="HD1">I. Background</HD>
        <P>
        In accordance with the Privacy Act of 1974, 5 U.S.C. 552a, the Department of Homeland Security (DHS) United States Secret Service (USSS) proposes to modify and reissue a current DHS system of records titled, DHS/USSS 004 Protection Information System of Records. Information collected in this
        <PRTPAGE P="64520"/>
        system of records is used to assist USSS in protecting its designated protectees, events, and venues. In doing so, USSS maintains necessary information to implement protective measures and to make protective inquiries concerning individuals who may come into proximity of a protectee, access a protected facility or event, or who have been involved in incidents or events that relate to the protective functions of USSS. Further, USSS ensures this protective information is appropriately managed and accessible to authorized users while employing appropriate safeguards to ensure that information is properly protected in accordance to national security standards.
        </P>
        <P>DHS/USSS is updating this SORN to:</P>
        <P>(1) Update the categories of individuals to include individuals who could be in proximity to protected persons or areas secured by USSS;</P>
        </SUPLINF>
        HEREDOC
      end

      it "returns clean string" do
        expected_content = "I. Background In accordance with the Privacy Act of 1974, 5 U.S.C. 552a, the Department of Homeland Security (DHS) United States Secret Service (USSS) proposes to modify and reissue a current DHS system of records titled, DHS/USSS 004 Protection Information System of Records. Information collected in this  system of records is used to assist USSS in protecting its designated protectees, events, and venues. In doing so, USSS maintains necessary information to implement protective measures and to make protective inquiries concerning individuals who may come into proximity of a protectee, access a protected facility or event, or who have been involved in incidents or events that relate to the protective functions of USSS. Further, USSS ensures this protective information is appropriately managed and accessible to authorized users while employing appropriate safeguards to ensure that information is properly protected in accordance to national security standards. DHS/USSS is updating this SORN to: (1) Update the categories of individuals to include individuals who could be in proximity to protected persons or areas secured by USSS;"
        expect(parser.get_supplementary_information).to eq expected_content
      end
    end
  end

  describe ".find_section" do
    it "returns clean string" do
      expect(parser.find_section("SECURITY")).to eq "Unclassified."
    end
  end

  describe ".get_sections" do
    it "gets all the sections of the PRIACT tag" do
      expect(parser.send(:get_sections)).to include "SECURITY CLASSIFICATION:" => "Unclassified."
    end

    context "with a rare hash header" do
      let(:xml) do
        <<~HEREDOC
        <PRIACT>
        <HD SOURCE="HD2">
          <E T="04">System manager and address:</E>
        </HD>
        <P>WHATEVER</P>
        </PRIACT>
        HEREDOC
      end

      it "still gets that section" do
        expect(parser.send(:get_sections)).to include "System manager and address:" => "WHATEVER"
      end
    end
  end

  describe ".get_system_number" do
    let(:system_name) { "GSA/OGP-1, e-Rulemaking Program Administrative System., OKAY ANOTHER THING" }

    before do
      allow(parser).to receive(:find_section).and_return(system_name)
      parser.get_system_name
    end

    context "with a / in the number" do
      it "returns the system number" do
        expect(parser.get_system_number).to eq "GSA/OGP-1"
      end
    end

    context "with no number in the identifier" do
      let(:system_name) { "National Docketing Management Information System (NDMIS)" }

      it "returns nil" do
        expect(parser.get_system_number).to eq nil
      end
    end

    context "with a number only number" do
      let(:system_name) { "Family Advocacy Program Record.	2003-11-18" }

      it "returns the number" do
        expect(parser.get_system_number).to eq "2003-11-18"
      end
    end

    context "with a parenthetical number" do
      let(:system_name) { "Criminal Investigations (11VA51)." }

      it "returns the number" do
        expect(parser.get_system_number).to eq "11VA51"
      end
    end

    context "with a period in the identifier" do
      let(:system_name) { "CFPB.009—Employee Administrative Records System." }

      it "returns the number" do
        expect(parser.get_system_number).to eq "CFPB.009"
      end
    end

    context "Has an excluded regex capture" do
      context "excludes the cfr and date references" do
        let(:system_name) { "Database of Reserve/Retired Judge Advocates and Legalmen (July 14, 1999, 64 FR 37944)." }

        it "returns nil" do
          expect(parser.get_system_number).to eq nil
        end
      end

      context "excludes the HSPD-12 references" do
        let(:system_name) { "HSPD-12: Identity Management, Personnel Security, Physical and Logical Access Files." }

        it "returns nil" do
          expect(parser.get_system_number).to eq nil
        end
      end
    end
  end
end