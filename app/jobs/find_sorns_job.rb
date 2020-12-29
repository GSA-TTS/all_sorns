class FindSornsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      FederalRegisterClient.new.find_sorns
    rescue => e
      p e.exception
    end
  end
end
