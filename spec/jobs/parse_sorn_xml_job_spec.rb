require 'rails_helper'

RSpec.describe ParseSornXmlJob, type: :job do
  before { allow($stdout).to receive(:write) } # silent puts

  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

    it "Enqueues a job" do
      expect {
        ParseSornXmlJob.perform_later()
      }.to have_enqueued_job
    end
  end

  context "when the job runs" do
    let(:sorn) { create :sorn }
    let(:xml_response) do
      OpenStruct.new(success?: true, parsed_response: file_fixture("sorn.xml").read)
    end

    before do
      allow(Sorn).to receive(:find).and_return sorn
      allow(sorn).to receive(:get_xml).and_call_original
      allow(HTTParty).to receive(:get).and_return xml_response
      allow(sorn).to receive(:parse_xml)
    end

    it "calls get_xml and parse_xml" do
      ParseSornXmlJob.perform_now(sorn.id)

      expect(sorn).to have_received(:get_xml)
      expect(sorn).to have_received(:parse_xml)
    end

    context "with no xml_url" do
      let(:sorn) { create :sorn, xml_url: nil }

      it "doesn't call .get_xml" do
        ParseSornXmlJob.perform_now(sorn.id)

        expect(sorn).not_to have_received(:get_xml)
      end
    end

    context "with existing xml" do
      let(:sorn) do
        xml = file_fixture("sorn.xml").read
        create(:sorn, xml: xml)
      end

      it "doesn't call .get_xml" do
        ParseSornXmlJob.perform_now(sorn.id)

        expect(sorn).not_to have_received(:get_xml)
        expect(sorn).to have_received(:parse_xml)
      end
    end

    context "bug - with computer matching action" do
      let(:sorn) do
        xml = file_fixture("sorn.xml").read
        create(:sorn, xml: xml, action: "computer matching")
      end

      it "succeeds" do
        expect { ParseSornXmlJob.perform_now(sorn.id) }.to_not raise_error
      end
    end
  end
end

