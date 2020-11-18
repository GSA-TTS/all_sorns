class AnalyticsController < ApplicationController
  def index
    @total_sorns = Sorn.count
    @sorn_types = Sorn.pluck(:action_type).tally
    @agencies = Agency.all
  end
end
