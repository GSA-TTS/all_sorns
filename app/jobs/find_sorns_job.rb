class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    FederalRegisterClient.new.find_sorns
  end
end
