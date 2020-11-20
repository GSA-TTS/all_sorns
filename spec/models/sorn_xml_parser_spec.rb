require 'rails_helper'

RSpec.describe SornXmlParser, type: :model do
  let(:parser) do
    xml = file_fixture("sorn.xml").read
    SornXmlParser.new(xml)
  end

  describe ".get_system_number" do
    let(:system_name) { "GSA/OGP-1, e-Rulemaking Program Administrative System., OKAY ANOTHER THING" }

    before do
      allow(parser).to receive(:find_section).and_return([system_name])
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