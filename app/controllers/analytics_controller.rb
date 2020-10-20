class AnalyticsController < ApplicationController
    def index

        @total_sorns = Sorn.count

        @agency_sorn_counts = Sorn.group(:agency_names).count.sort_by{ |name, count| count }.reverse

    end
end
