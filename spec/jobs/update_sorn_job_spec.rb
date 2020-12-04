require 'rails_helper'

RSpec.describe UpdateSornJob, type: :job do
  before { allow($stdout).to receive(:puts) } # silent puts

  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

    it "Enqueues a job" do
      expect {
        described_class.perform_later()
      }.to have_enqueued_job
    end
  end

  context "when the job runs" do
    let(:sorn) { create :sorn }

    before do
      allow(Sorn).to receive(:find).and_return sorn
      allow(sorn).to receive(:get_action_type)
      allow(sorn).to receive(:get_xml)
      allow(sorn).to receive(:parse_xml)
      allow(sorn).to receive(:update_mentioned_sorns)
    end

    it "calls methods to get more data" do
      described_class.perform_now(sorn.id)

      expect(sorn).to have_received(:get_action_type)
      expect(sorn).to have_received(:get_xml)
      expect(sorn).to have_received(:parse_xml)
      expect(sorn).to have_received(:update_mentioned_sorns)
    end

    context "bug - with computer matching action" do
      let(:sorn) do
        xml = file_fixture("sorn.xml").read
        create(:sorn, xml: xml, action: "computer matching")
      end

      it "succeeds" do
        expect { described_class.perform_now(sorn.id) }.to_not raise_error
      end
    end
  end
end

