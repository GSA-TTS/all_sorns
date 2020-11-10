class ParseSornXmlJob < ApplicationJob
    queue_as :default
  
    def perform(sorn_id)
      sleep 1
  
      sorn = Sorn.find(sorn_id)
      sorn.update_action_type if sorn.action
      puts "Cleaned #{sorn.id} action type"
    end
  end