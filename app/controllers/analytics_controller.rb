class AnalyticsController < ApplicationController
  def index
    @total_sorns = Sorn.count
    @sorn_types = Sorn.pluck(:action_type).tally
    @agencies = Agency.all

    #count of different types of SORNs - new,modified, rescinded, matching agreements, others

    #Data quality stats
    #How many records don't have titles?
    #How many records are missing ___ field?

    #which SORNs don't have XML links?post
  end
end
