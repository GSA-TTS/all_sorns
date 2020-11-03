require 'rails_helper'

RSpec.describe FindSornsJob, type: :job do
  # before { allow($stdout).to receive(:write) } # silent puts

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
      it "calls FederalRegisterApi.find_sorns" do
        expect(FederalRegisterApi).to receive(:find_sorns)
        FindSornsJob.perform_now
      end
    end
  end
end
