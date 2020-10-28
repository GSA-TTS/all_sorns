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
    let(:sorn) do
      xml = file_fixture("sorn.xml").read
      create(:sorn, xml: xml)
    end

    it "calls get_xml and parse_xml" do
      allow(Sorn).to receive(:find).and_return sorn
      expect(sorn).to receive(:get_xml)
      expect(sorn).to receive(:parse_xml)

      ParseSornXmlJob.perform_now(sorn.id)
    end
  end
end

