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
      let(:type) { "Notice" }
      let(:pages) { 1 }
      let(:title) { "Privacy Act of 1974; System of Records" }

      before do
        mock_result = OpenStruct.new(
          title: title,
          action: "api action",
          dates: "api dates",
          pdf_url: "pdf url",
          full_text_xml_url: "expected url",
          html_url: "html url",
          citation: "citation",
          type: type,
          publication_date: "2000-01-13",
          agencies: [
            OpenStruct.new(
              "raw_name": "FAKE PARENT AGENCY",
              "name": "Fake Parent Agency",
              "id": 1,
              "parent_id": nil
            ),
            OpenStruct.new(
              "raw_name": "FAKE CHILD AGENCY",
              "name": "Fake Child Agency",
              "id": 2,
              "parent_id": 1
            )
          ],
          agency_names: ["Fake Parent Agency", "Fake Child Agency"]
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

        it "Creates agencies for each result" do
          expect{ FindSornsJob.perform_now }.to change{ Agency.count }.by 2
        end

        it "has the expected attributes" do
          FindSornsJob.perform_now

          sorn = Sorn.last
          expect(sorn.action).to eq 'api action'
          expect(sorn.dates).to eq 'api dates'
          expect(sorn.citation).to eq 'citation'
          expect(sorn.xml_url).to eq 'expected url'
          expect(sorn.html_url).to eq 'html url'
          expect(sorn.pdf_url).to eq 'pdf url'
          expect(sorn.data_source).to eq 'fedreg'
          expect(sorn.publication_date).to eq "2000-01-13"
        end
      end

      context "with existing SORN" do
        let!(:sorn) { create :sorn }

        it "updates existing SORN" do
          expect{ FindSornsJob.perform_now; sorn.reload }.to change{ sorn.xml_url }.from('xml_url').to('expected url')
        end
      end

      it "Calls ParseSornXML job with the xml url." do
        FindSornsJob.perform_now

        expect(ParseSornXmlJob).to have_received(:perform_later).with(Sorn.last.id)
      end

      context "with a an non-notice sorn" do
        let(:type) { "Proposed Rule" }

        it "Doesn't call ParseSornMxlJob" do
          FindSornsJob.perform_now

          expect(ParseSornXmlJob).not_to have_received(:perform_later)
        end
      end

      context "with more than one page" do
        let(:pages) { 2 }

        it "Calles ParseSornXmlJob for each page" do
          FindSornsJob.perform_now

          expect(ParseSornXmlJob).to have_received(:perform_later).twice
        end
      end

      context "Privacy Act" do
        let(:title) { "Privacy Act" }

        it "creates a sorn" do
          expect{ FindSornsJob.perform_now }.to change{ Sorn.count }.by 1
        end
      end

      context "Systems of Record" do
        let(:title) { "Systems of Record" }

        it "creates a sorn" do
          expect{ FindSornsJob.perform_now }.to change{ Sorn.count }.by 1
        end
      end

      context "Computer matching" do
        let(:title) { "Computer matching" }

        it "creates a sorn" do
          expect{ FindSornsJob.perform_now }.to change{ Sorn.count }.by 1
        end
      end
    end
  end
end
