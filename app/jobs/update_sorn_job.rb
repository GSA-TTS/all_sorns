class UpdateSornJob < ApplicationJob
  queue_as :default

  def perform(sorn_id)
    sorn = Sorn.find(sorn_id)
    sorn.get_action_type
    sorn.get_xml
    sorn.parse_xml
    sorn.update_mentioned_sorns
    puts "Updated #{sorn.id}"
  end
end
