require 'rails_helper'

RSpec.describe ParseSornXmlJob, type: :job do
  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

    it "Enqueues a job" do
      expect {
        ParseSornXmlJob.perform_later('xml url', 'html url')
      }.to have_enqueued_job
    end

    before { allow($stdout).to receive(:write) } # silent puts

    it "Parses an xml file and creates a SORN" do
      parsed_response = "<sorn>HELLO</sorn>" #file_fixture("sorn.xml").read
      mock_response = OpenStruct.new(success?: true, parsed_response: parsed_response)
      mock_parser = OpenStruct.new(parse_sorn: { agency: "Fake Agency", system_name_and_number: "Fake SORN" })
      allow(HTTParty).to receive(:get).and_return mock_response

      expect(SornXmlParser).to receive(:new).with(parsed_response).and_return mock_parser
      expect(Agency).to receive(:find_or_create_by).with(name: "Fake Agency").and_call_original
      expect(Sorn).to receive(:create).with(hash_including(system_name_and_number: "Fake SORN", xml_url: "xml url"))

      ParseSornXmlJob.perform_now('xml url', 'html url')
    end
  end
end
