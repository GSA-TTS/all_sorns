class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    FederalRegisterApi.find_sorns
  end
end
