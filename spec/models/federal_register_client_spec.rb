require 'rails_helper'

RSpec.describe FederalRegisterClient, type: :model do
  let(:title) { "Privacy Act of 1974; System of Records" }
  let(:action) { "api action" }
  let(:type) { "Notice" }
  let(:pages) { 1 }
  let(:client) { described_class.new }

  before do
    mock_result = OpenStruct.new(
      title: title,
      action: action,
      dates: "api dates",
      pdf_url: "pdf url",
      full_text_xml_url: "expected url",
      html_url: "html url",
      citation: "FAKE CITATION 1",
      type: type,
      publication_date: "2000-01-13",
      agencies: [
        OpenStruct.new(
          "raw_name": "PARENT AGENCY",
          "name": "Fake Parent Agency",
          "id": 1,
          "parent_id": nil
        ),
        OpenStruct.new(
          "raw_name": "CHILD AGENCY",
          "name": "Fake Child Agency",
          "id": 2,
          "parent_id": 1
        )
      ]
    )
    parent_agency_result = OpenStruct.new(
      short_name: "Parent"
    )
    child_agency_result = OpenStruct.new(
      short_name: "Child"
    )
    result_set = double(FederalRegister::ResultSet, results: [mock_result], total_pages: pages)
    allow($stdout).to receive(:puts)
    allow(FederalRegister::Document).to receive(:search).and_return result_set
    allow(FederalRegister::Document).to receive(:find).and_return mock_result
    allow(FederalRegister::Agency).to receive(:find).with(1).and_return parent_agency_result
    allow(FederalRegister::Agency).to receive(:find).with(2).and_return child_agency_result
    allow(FullSornSearch).to receive(:refresh)

    allow(UpdateSornJob).to receive(:perform_later)
  end

  describe "#find_sorns" do
    it "Makes a federal register api call" do
      client.find_sorns

      expect(FederalRegister::Document).to have_received(:search)
    end

    context "finds a new SORN" do
      it "Creates a Sorn for each result" do
        expect{ client.find_sorns }.to change{ Sorn.count }.by 1
      end

      it "Creates agencies for each result" do
        expect{ client.find_sorns }.to change{ Agency.count }.by 2

        expect(Sorn.last.agencies.second).to have_attributes(name: "Parent Agency", api_id: 1, parent_api_id: nil)
        expect(Sorn.last.agencies.first).to have_attributes(name: "Child Agency", api_id: 2, parent_api_id: 1)
      end

      it "makes another Federal Register API request for the agency short_name" do
        client.find_sorns

        expect(FederalRegister::Agency).to have_received(:find).twice
        expect(Sorn.last.agencies.second.short_name).to eq "Parent"
        expect(Sorn.last.agencies.first.short_name).to eq "Child"
      end

      context "with existing agencies" do
        let(:sorn) { create :sorn, agencies: [] }

        before do
          sorn.agencies << Agency.create(name: "Parent Agency", api_id: 1, parent_api_id: nil, short_name: "Parent")
          sorn.agencies << Agency.create(name: "Child Agency", api_id: 2, parent_api_id: 1, short_name: "Child")
        end

        it "Doesn't duplicate agencies" do
          client.find_sorns
          expect(sorn.agencies.count).to eq 2
        end
      end

      it "has the expected attributes" do
        client.find_sorns

        sorn = Sorn.last
        expect(sorn.agency_names).to eq 'Parent Agency | Child Agency'
        expect(sorn.action).to eq 'api action'
        expect(sorn.dates).to eq 'api dates'
        expect(sorn.citation).to eq 'FAKE CITATION 1'
        expect(sorn.xml_url).to eq 'expected url'
        expect(sorn.html_url).to eq 'html url'
        expect(sorn.pdf_url).to eq 'pdf url'
        expect(sorn.data_source).to eq 'fedreg'
        expect(sorn.publication_date).to eq "2000-01-13"
      end

      context "DoD Office of the Secretary" do
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
                "raw_name": "DEPARTMENT OF DEFENSE",
                "name": "Defense Department",
                "id": 103,
                "parent_id": nil
              ),
              OpenStruct.new(
                "raw_name": "Office of the Secretary"
              )
            ]
          )
          dod_agency_result = OpenStruct.new(
            short_name: "DOD"
          )
          result_set = double(FederalRegister::ResultSet, results: [mock_result], total_pages: pages)
          allow(FederalRegister::Document).to receive(:search).and_return result_set
          allow(FederalRegister::Agency).to receive(:find).with(103).and_return dod_agency_result
        end

        it "don't save subcomponents without metadata" do
          expect{ client.find_sorns }.to change{ Agency.count }.by 1

          expect(Sorn.last.agencies.first).to have_attributes(name: "Department Of Defense", api_id: 103, parent_api_id: nil)
        end

        it "does write subcomponents to agency_names though" do
          client.find_sorns

          expect(Sorn.last.agency_names).to eq "Department Of Defense | Office Of The Secretary"
        end
      end
    end

    context "with existing SORN" do
      let!(:sorn) { create :sorn, citation: "FAKE CITATION 1", xml_url: nil }

      it "updates existing SORN" do
        expect{ client.find_sorns; sorn.reload }.to change{ sorn.xml_url }.from(nil).to('expected url')
      end
    end

    it "Calls UpdateSornJob job with the xml url." do
      client.find_sorns

      expect(UpdateSornJob).to have_received(:perform_later).with(Sorn.last.id)
    end

    context "with a an non-notice sorn" do
      let(:type) { "Proposed Rule" }

      it "Doesn't call UpdateSornJob" do
        client.find_sorns

        expect(UpdateSornJob).not_to have_received(:perform_later)
      end
    end

    context "with more than one page" do
      let(:pages) { 2 }

      it "Calls UpdateSornJob for each page" do
        client.find_sorns

        expect(UpdateSornJob).to have_received(:perform_later).twice
      end

      it "refreshes the search after the find_sorns job" do
        client.find_sorns

        expect(FullSornSearch).to have_received(:refresh).once
      end
    end

    context "Privacy Act" do
      let(:title) { "Privacy act" }

      it "creates a sorn" do
        expect{ client.find_sorns }.to change{ Sorn.count }.by 1
      end
    end

    context "Systems of Record" do
      let(:title) { "systems OF Records" }

      it "creates a sorn" do
        expect{ client.find_sorns }.to change{ Sorn.count }.by 1
      end
    end

    context "Computer matching" do
      context "in the title" do
        let(:title) { "Privacy Act of 1974; Computer Matching Program" }

        it "does not create a SORN" do
          expect{ client.find_sorns }.not_to change{ Sorn.count }
        end
      end

      context "in the action" do
        let(:action) { "Notice of a New Matching Program." }

        it "does not create a SORN" do
          expect{ client.find_sorns }.not_to change{ Sorn.count }
        end
      end
    end

    context "Something else besides privacy" do
      let(:title) { "Something else besides privacy" }

      it "creates a sorn" do
        expect{ client.find_sorns }.to_not change{ Sorn.count }
      end
    end
  end

  describe "#add_sorn_by_url" do
    it "creates a new sorn" do
      url = "https://www.federalregister.gov/documents/2003/06/24/03-15911/privacy-act-notice"
      expect{ client.add_sorn_by_url(url) }.to change{ Sorn.count }.by 1
    end

    context "even without the exepected titles" do
      let(:title) { "No title availalble" }

      it "creates a new sorn" do
        url = "https://www.federalregister.gov/documents/2007/05/29/07-2638/no-title-available"
        expect{ client.add_sorn_by_url(url) }.to change{ Sorn.count }.by 1
      end
    end
  end
end