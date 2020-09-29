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
      let(:title) { "Privacy Act of 1974; System of Records" }
      let(:pages) { 1 }

      before do
        mock_results = [OpenStruct.new(title: title, full_text_xml_url: "expected url", html_url: "html url")]
        result_set = double(FederalRegister::ResultSet, results: mock_results, total_pages: pages)
        allow(FederalRegister::Document).to receive(:search).and_return result_set
        allow(ParseSornXmlJob).to receive(:perform_later)

        FindSornsJob.perform_now
      end

      it "Makes a federal register api call" do
        expect(FederalRegister::Document).to have_received(:search)
      end

      it "Calls ParseSornXML job with the xml url." do
        expect(ParseSornXmlJob).to have_received(:perform_later).with("expected url", "html url")
      end

      context "with unwanted SORN titles" do
        excluded_titles = [
          "Privacy Act of 1974; Matching",
          "Privacy Act of 1974; rulemaking sorn",
          "Privacy Act of 1974; Implementation SORN"
        ]

        excluded_titles.each do |excluded_title|
          let(:title) { excluded_title }

          it "Doesn't call ParseSornMxlJob" do
            expect(ParseSornXmlJob).not_to have_received(:perform_later)
          end
        end
      end

      context "with more than one page" do
        let(:pages) { 2 }

        it "Calles ParseSornXmlJob for each page" do
          expect(ParseSornXmlJob).to receive(:perform_later).twice

          FindSornsJob.perform_now
        end
      end
    end
  end
end
