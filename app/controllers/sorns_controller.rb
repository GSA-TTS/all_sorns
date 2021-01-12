class SornsController < ApplicationController
  def search
    @sorns = Sorn.none if params[:search].blank? # blank page on first visit
    @fields_to_search = params[:fields] || Sorn::FIELDS # use either selected fields or all of them
    @sorns = filter_on_search if params[:search].present?
    @sorns = filter_on_agencies if params[:agencies]
    @sorns = filter_on_publication_date if params[:starting_year].present? || params[:ending_year].present?
    @sorns = only_exact_matches if multiword_search?

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

  private

  def filter_on_search
    if @fields_to_search == Sorn::FIELDS
      # If we are seaching the whole SORN, use the materialized view
      @sorns = Sorn.no_computer_matching.where(id: FullSornSearch.search(params[:search]).select(:sorn_id))
    else
      # or search a list tsvectors columns
      @sorns = Sorn.no_computer_matching.dynamic_search(@fields_to_search, params[:search])
    end
  end

  def filter_on_agencies
    @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
    # Matching on agencies could return duplicates, so get distinct
    if @fields_to_search == Sorn::FIELDS
       @sorns.get_distinct
    else
      @sorns.get_distinct_with_dynamic_search_rank
    end
  end

  def filter_on_publication_date
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

    return @sorns
  end

  def multiword_search?
    params[:search].scan(/\w+/).size > 1 if params[:search].present?
  end

  def only_exact_matches
    @sorns.only_exact_matches(params[:search], @fields_to_search)
  end
end
