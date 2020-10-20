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
      let(:type) { "Notice" }

      before do
        mock_result = OpenStruct.new(
          title: title,
          full_text_xml_url: "expected url",
          html_url: "html url",
          citation: "citation",
          type: type,
          agency_names: ['My Favorite Agency']
        )
        mock_results = [mock_result]
        result_set = double(FederalRegister::ResultSet, results: mock_results, total_pages: pages)
        allow(FederalRegister::Document).to receive(:search).and_return result_set
        allow(ParseSornXmlJob).to receive(:perform_later)
      end

      it "Makes a federal register api call" do
        FindSornsJob.perform_now

        expect(FederalRegister::Document).to have_received(:search)
      end

      describe "finds a new SORN" do
        it "Creates a Sorn for each result" do
          expect{ FindSornsJob.perform_now }.to change{ Sorn.count }.by 1
        end

        it "has the expected attributes" do
          FindSornsJob.perform_now

          sorn = Sorn.last
          expect(sorn.citation).to eq 'citation'
          expect(sorn.xml_url).to eq 'expected url'
          expect(sorn.html_url).to eq 'html url'
          expect(sorn.agency_names).to eq "[\"My Favorite Agency\"]"
          expect(sorn.data_source).to eq 'fedreg'
        end
      end

      describe "with existing SORN" do
        it "updates existing SORN" do
          sorn = create(:sorn)

          expect{ FindSornsJob.perform_now; sorn.reload }.to change{ sorn.xml_url }.from('xml_url').to('expected url')
        end
      end

      it "Calls ParseSornXML job with the xml url." do
        FindSornsJob.perform_now

        expect(ParseSornXmlJob).to have_received(:perform_later)
          .with(Sorn.last.id)
      end

      context "with a an non-notice sorn" do
        let(:type) { "Proposed Rule" }

        it "Doesn't call ParseSornMxlJob" do
          FindSornsJob.perform_now

          expect(ParseSornXmlJob).not_to have_received(:perform_later)
        end
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
            FindSornsJob.perform_now

            expect(ParseSornXmlJob).not_to have_received(:perform_later)
          end
        end
      end

      context "with more than one page" do
        let(:pages) { 2 }

        it "Calles ParseSornXmlJob for each page" do
          FindSornsJob.perform_now

          expect(ParseSornXmlJob).to have_received(:perform_later).twice
        end
      end
    end
  end
end
