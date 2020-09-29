require 'rails_helper'

RSpec.describe FindSornsJob, type: :job do
  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

     it "Enqueues a job" do
      expect {
        FindSornsJob.perform_later
      }.to have_enqueued_job
    end

    it "Makes a federal register api call" do
      result_set = double(FederalRegister::ResultSet, results: [], total_pages: 1)
      allow(FederalRegister::Document).to receive(:search).and_return result_set

      FindSornsJob.perform_now

      expect(FederalRegister::Document).to have_received(:search)
    end

    context "with SORN results" do
      it "Calls ParseSornXML job with the xml url." do
        mock_results = [OpenStruct.new(title: "Privacy Act of 1974", full_text_xml_url: "expected url")]
        result_set = double(FederalRegister::ResultSet, results: mock_results, total_pages: 1)
        allow(FederalRegister::Document).to receive(:search).and_return result_set

        expect(ParseSornXmlJob).to receive(:perform_later).with("expected url")

        FindSornsJob.perform_now
      end

      context "with an unwanted SORN title" do
        it "Doesn't call ParseSornMxlJob" do
          mock_results = [OpenStruct.new(title: "Privacy Act of 1974; Matching Program")]
          result_set = double(FederalRegister::ResultSet, results: mock_results, total_pages: 1)
          allow(FederalRegister::Document).to receive(:search).and_return result_set

          expect(ParseSornXmlJob).not_to receive(:perform_later)

          FindSornsJob.perform_now
        end
      end

      context "with more than one page" do
        it "Calles ParseSornXmlJob" do
          mock_results = [OpenStruct.new(title: "Privacy Act of 1974")]
          result_set = double(FederalRegister::ResultSet, results: mock_results, total_pages: 2)
          allow(FederalRegister::Document).to receive(:search).and_return result_set

          expect(ParseSornXmlJob).to receive(:perform_later).twice

          FindSornsJob.perform_now
        end
      end
    end
  end
end
