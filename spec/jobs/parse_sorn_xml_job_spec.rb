require 'rails_helper'

RSpec.describe ParseSornXmlJob, type: :job do
  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

    it "Enqueues a job" do
      expect {
        ParseSornXmlJob.perform_later()
      }.to have_enqueued_job
    end
  end

  context "when the job runs" do
    let(:sorn) { create(:sorn) }

    it "calls get_xml and parse_xml" do
      allow(Sorn).to receive(:find).and_return sorn
      expect(sorn).to receive(:get_xml)
      expect(sorn).to receive(:parse_xml)

      ParseSornXmlJob.perform_now(sorn.id)
    end
  end
end

