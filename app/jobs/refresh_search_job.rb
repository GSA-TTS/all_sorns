class RefreshSearchJob < ApplicationJob
  queue_as :default

  def perform(*args)
    FullSornSearch.refresh
    puts "Refreshed search"
  end
end
