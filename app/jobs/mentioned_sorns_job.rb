class MentionedSornsJob < ApplicationJob
  queue_as :default

  def perform(sorn_id)
    sorn = Sorn.find(sorn_id)
    sorn.get_mentioned_sorns
  end
end
