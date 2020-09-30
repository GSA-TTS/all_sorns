class BulkSornParser
  def self.work
    begin

      xml = File.open('data/PAI-2019-GSA.xml').read
      json_str = Hash.from_xml(xml).to_json
      json = JSON.parse(json_str)

      agency = Agency.find_or_create_by(name: json["pai"]["agency"]["name"])
      sorns = json["pai"]["agency"]["section"]
      sorns.each do |sorn|
        system_number = sorn["systemNumber"]
        if sorn["subsection"].class == Array
          system_name = sorn["subsection"].shift
            # transform the subsections
          subsections = {}
          sorn["subsection"].each {|subsection| subsections[subsection["type"]] = subsection["xhtmlContent"]["p"] }

          Sorn.create!(
            agency: agency,
            system_number: system_number,
            system_name: system_name,
            security: subsections["securityClassification"],
            location: subsections["systemLocation"],
            manager: subsections["systemManager"],
            authority: subsections["authorityForMaintenance"],
            purpose: subsections["purpose"],
            categories_of_individuals: subsections["categoriesOfIndividuals"],
            categories_of_record: subsections["categoriesOfRecords"],
            source: subsections["recordSourceCategories"],
            routine_uses: subsections["routineUsesOfRecords"],
            storage: subsections["storage"],
            retrieval: subsections["retrievability"],
            retention: subsections["retentionAndDisposal"],
            safeguards: subsections["safeguards"],
            access: subsections["recordAccessProcedures"],
            contesting: subsections["contestingRecordProcedures"],
            notification: subsections["notificationProcedure"],
            exemptions: subsections["exemptionsClaimed"],
            history: subsections["history"]
          )
        else
          system_name = sorn["subsection"]
          Sorn.create!(
            agency: agency,
            system_number: system_number,
            system_name: system_name
          )
        end
      end
    rescue => exception

      binding.pry
    end

  end
end