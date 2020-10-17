require 'rails_helper'

RSpec.describe Sorn, type: :model do
  let(:sorn) { create(:sorn) }

  describe ".get_xml" do
    it "request the xml" do
      parsed_response = file_fixture("sorn.xml").read
      mock_response = OpenStruct.new(success?: true, parsed_response: parsed_response)
      allow(HTTParty).to receive(:get).and_return mock_response

      sorn.get_xml

      expect(sorn.xml).to eq parsed_response
    end
  end

  describe ".parse_xml" do
    let(:sorn) do
      xml = file_fixture("sorn.xml").read
      create(:sorn, xml: xml)
    end

    it "successfully updates the sorn" do
      expect(sorn.action).to be_nil
      expect(sorn.parse_xml).to be_truthy
      expect(sorn.action).to eq "Notice of a new system of records."
    end
  end
end