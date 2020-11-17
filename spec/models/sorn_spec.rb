require 'rails_helper'

RSpec.describe Sorn, type: :model do
  let(:sorn) { create(:sorn) }
  let(:parsed_response) { file_fixture("sorn.xml").read }

  before do
    mock_response = OpenStruct.new(success?: true, parsed_response: parsed_response)
    allow(HTTParty).to receive(:get).and_return mock_response
    allow(sorn).to receive(:update).and_call_original
  end

  describe ".get_xml" do
    it "request the xml" do
      sorn.get_xml

      expect(sorn.xml).to eq parsed_response
    end

    context "with no xml_url" do
      let(:sorn) { create :sorn, xml_url: nil }

      it "doesn't call make any http requests" do
        sorn.get_xml

        expect(HTTParty).not_to have_received(:get)
      end
    end
  end

  describe ".parse_xml" do
    let(:sorn) do
      xml = file_fixture("sorn.xml").read
      create(:sorn, security: nil, xml: xml)
    end

    it "successfully updates the sorn" do
      expect { sorn.parse_xml }.to change { sorn.security }.from(nil).to("[\"Unclassified.\"]")
    end

    it "parses as expected" do
      sorn.parse_xml

      expect(sorn.summary).to start_with "[\"\\nGSA is publishing this system"
      expect(sorn.addresses).to start_with "[\"Submit comments identified by “Notice-ID-2019-01,"
      expect(sorn.further_info).to start_with "[\"\\nCall or email GSA's Chief Privacy Officer: tel"
      expect(sorn.supplementary_info).to start_with "[\"The e-Rulemaking Program has been managed by the "
      expect(sorn.system_name).to eq "GSA/OGP-1, e-Rulemaking Program Administrative System., OKAY ANOTHER THING"
      expect(sorn.system_number).to eq "[\"GSA/OGP-1, e-Rulemaking Program Administrative System.\", \"OKAY ANOTHER THING\"]"
      expect(sorn.security).to eq "[\"Unclassified.\"]"
      expect(sorn.location).to eq "[\"National Computer Center in Research Triangle Park, North Carolina.\"]"
      expect(sorn.manager).to include "The system manager is the Associate Chief Information Officer of Corporate IT Services in GSA-IT"
      expect(sorn.authority).to eq "[[\"\\ne-Government Act of 2002, see 44 U.S.C. 3602(f)(6); see also id § 3501, note.\\n\", {}]]"
      expect(sorn.purpose).to include "The purpose of the e-Rulemaking Program Administrative System is to"
      expect(sorn.categories_of_individuals).to include "Covered individuals are partner agency users who"
      expect(sorn.categories_of_record).to start_with "[\"GSA maintains partner agencies' users' names, government issued email addresses,"
      expect(sorn.source).to start_with "[\"The information in the system may be submitted"
      expect(sorn.routine_uses).to start_with "[\"In addition to those disclosures generally permitted under 5 U.S.C. 552a(b)"
      expect(sorn.storage).to start_with "[\"User credentials and associated documentation are stored on"
      expect(sorn.retrieval).to start_with "[\"The e-Rulemaking Program Administrative System retrieves "
      expect(sorn.retention).to start_with "[\"Records relating to user credentials"
      expect(sorn.safeguards).to start_with "[\"The e-Rulemaking Program Administrative System is in a facility"
      expect(sorn.access).to start_with "[\"Partner agency users can access and manage their user credentials through"
      expect(sorn.contesting).to start_with "[\"If partner agency users have questions"
      expect(sorn.notification).to start_with "[\"If partner agency users wish to receive notice about their account records,"
      expect(sorn.exemptions).to eq "[\"None.\"]"
      expect(sorn.history).to eq "[\"N/A.\"]"
    end

    context "with no xml" do
      let(:sorn) { create :sorn, xml: nil }

      it "doesn't parse the xml" do
        sorn.parse_xml

        expect(sorn).not_to have_received(:update)
      end
    end
  end

  describe ".get_action_type" do
    context "Computer Matching Agreement" do
      actions = ["Notice of a new matching program.",
        "Notice of Computer Matching Program.",
        "Notice of a Computer Matching Program Between HUD and DHS/FEMA.",
        "Notice of a modified matching program."
      ]

      it "return expected action_type" do
        actions.each do |action|
          sorn.update(action: action)
          sorn.get_action_type
          expect(sorn.action_type).to eq "Computer Matching Agreement"
        end
      end
    end

    context "New" do
      actions = ["new something", "Notice of system of records.",
        "Notice of Privacy Act system of records.", "Adding a system",
        "Notice of Privacy Act System of Records.", "Notice of systems of records.",
        "Proposed system", "Notice of Systems of Records.", "Public ..."]

      it "return expected action_type" do
        actions.each do |action|
          sorn.update(action: action)
          sorn.get_action_type
          expect(sorn.action_type).to eq "New"
        end
      end
    end

    context "Modification" do
      actions = ["Modified system","Altered system", "new blanket routine use",
        "Amendment to", "Revised", "Changes made to syste",
        "Updated System of Records", "New routine use"]

      it "return expected action_type" do
        actions.each do |action|
          sorn.update(action: action)
          sorn.get_action_type
          expect(sorn.action_type).to eq "Modification"
        end
      end
    end

    context "Exemption" do
      actions = ["Notice to establish an exempt system of records."]

      it "return expected action_type" do
        actions.each do |action|
          sorn.update(action: action)
          sorn.get_action_type
          expect(sorn.action_type).to eq "Exemption"
        end
      end
    end

    context "Rescindment" do
      actions = ["Rescindment of a", "Deleting a system", "rescission of system",
                 "retiring a system", "Withdrawing a"]

      it "return expected action_type" do
        actions.each do |action|
          sorn.update(action: action)
          sorn.get_action_type
          expect(sorn.action_type).to eq "Rescindment"
        end
      end
    end

    context "Renewal" do
      actions = ["Recertification of", "Renewal of", "re-establishment of", "Republication of a"]

      it "return expected action_type" do
        actions.each do |action|
          sorn.update(action: action)
          sorn.get_action_type
          expect(sorn.action_type).to eq "Renewal"
        end
      end
    end

    context "Unknown or Other" do
      it "doesn't raise an error" do
        sorn.update(action: nil)
        sorn.get_action_type
        expect(sorn.action_type).to eq "Unknown or Other"
      end
    end
  end
end
