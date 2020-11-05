class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = FederalRegisterClient.new
    client.find_sorns
  end
end
