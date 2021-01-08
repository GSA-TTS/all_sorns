class SornsController < ApplicationController
  def search
    @sorns = Sorn.none.page(params[:page]) and return if params[:search].blank? # blank page on first visit

    @fields_to_search = params[:fields] || Sorn::FIELDS # use either selected fields or all of them
    @sorns = Sorn.search(@fields_to_search, params[:search]).records # elasticsearch
    @sorns = @sorns.no_computer_matching
    @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]}) if params[:agencies]

    if params[:starting_year].present?
      # from beginning of start year
      starting_date = params[:starting_year] + "-01-01"
      @sorns = @sorns.where('publication_date::DATE > ?', starting_date)
    end

    if params[:ending_year].present?
      # to end of ending year
      ending_date = params[:ending_year] + "-12-31"
      @sorns = @sorns.where('publication_date::DATE < ?', ending_date)
    end

    if request.format == :html
      # only need to load mentioned and pagination for html
      @sorns = @sorns.includes(:mentioned)
      @sorns = @sorns.page(params[:page])
    end

    respond_to do |format|
      format.html
      format.csv { send_data @sorns.to_csv(@fields_to_search.map(&:to_s)), filename: "sorns-#{Date.today.to_s}.csv" }
    end
  end
end
