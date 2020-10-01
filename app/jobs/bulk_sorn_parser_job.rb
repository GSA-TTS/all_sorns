class BulkSornParserJob < ApplicationJob
  queue_as :default

  def perform(*args)
    parsed_response = HTTParty.get(args[0][:url]).parsed_response
    agency = Agency.find_or_create_by(name: parsed_response["pai"]["agency"]["name"])
    sorns = parsed_response["pai"]["agency"]["section"]
    sorns.each do |sorn|
      system_number = sorn["systemNumber"]

      # Almost all of the subsections are an array
      if sorn["subsection"].class == Array
        system_name = sorn["subsection"].shift["__content__"]
          # transform the subsections
        subsections = {}
        sorn["subsection"].each do |subsection|
          content = subsection["xhtmlContent"].try(:fetch, "p")


          if content.class == Hash
            content = content.values
          end

          if content.class == Array
            content = content.map do |p|
              p if p.class == String
            end.compact

            content = content.join
          end

          subsections[subsection["type"]] = content
        end

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
          history: subsections["history"],
          data_source: :bulk
        )
      else
        system_name = sorn["subsection"]["__content__"]
        Sorn.create!(
          agency: agency,
          system_number: system_number,
          system_name: system_name
        )
      end
    end
    puts "All done"
  end
end