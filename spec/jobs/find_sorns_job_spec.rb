require 'rails_helper'

RSpec.describe FindSornsJob, type: :job do
  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

    context "enqueuing for later" do
      it "Enqueues a job" do
        expect {
          FindSornsJob.perform_later
        }.to have_enqueued_job
      end
    end

    context "while performing" do
      it "calls .find_sorns" do
        expect(FederalRegisterClient).to receive_message_chain(:new, :find_sorns)
        FindSornsJob.perform_now
      end
    end
  end
end
