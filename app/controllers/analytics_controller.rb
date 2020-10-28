class AnalyticsController < ApplicationController
    def index

        @total_sorns = Sorn.count
        
        #Per agency stats
        #count of SORNs per agency
        @agency_sorn_counts = Sorn.except(:order).group(:agency_names).count.sort_by{ |name, count| count }.reverse

        #count of different types of SORNs - new,modified, rescinded, matching agreements, others

        #Data quality stats
        #How many records don't have titles?
        #How many records are missing ___ field?

        #which SORNs don't have XML links?post

    end
end
