class AnalyticsController < ApplicationController
  def index
    @total_sorns = Sorn.count
    @sorn_types = Sorn.pluck(:action_type).tally
    @agencies = Agency.all

    #Data quality stats
    @data_stats = {}
    @data_stats.merge!('No xml url': Sorn.where(xml_url: nil).count)
    @data_stats.merge!('Sorns with list-able CORs': Sorn.where("categories_of_record ~* ?", '•', ).count)
  

    end
end
