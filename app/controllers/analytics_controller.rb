class AnalyticsController < ApplicationController
    def index

        @total_sorns = Sorn.count

        @agency_sorn_counts = Sorn.group(:agency_names).count

    end
end
