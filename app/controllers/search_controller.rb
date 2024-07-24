class SearchController < ApplicationController
  def index
    @title = search_title
    @sorns = Sorn.none.page(params[:page]) # blank page on first visit
  end

  def search
    @fields_to_search = params[:fields] || Sorn::FIELDS # use either selected fields or all of them
    @sorns = filter_on_search
    @sorns = filter_on_agencies if params[:agencies]
    @sorns = filter_on_publication_date if publication_date_filter?
    @sorns = only_exact_matches if multiword_search?

    respond_to do |format|
      format.js { add_mentions_and_pagination }
      format.csv { create_csv_from_current_search }
    end
  end

  private

  def search_title
    if params[:search].present?
      "Search results for #{params[:search]} - "
    else
      ""
    end

  end

  def run_dynamic_search?
    params[:search].present?
  end

  def filter_on_search
    if !run_dynamic_search?
      Sorn.all
    elsif @fields_to_search == Sorn::FIELDS
      # If we are searching the whole SORN, just search the xml column
      Sorn.dynamic_search([:xml], params[:search])
    else
      # or search a list tsvectors columns
      Sorn.dynamic_search(@fields_to_search, params[:search])
    end
  end

  def filter_on_agencies
    filtered = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
    # Matching on agencies could return duplicates, so get distinct
    if run_dynamic_search?
      filtered.get_distinct_with_dynamic_search_rank
    else
      filtered.get_distinct_no_dynamic_search_rank
    end
  end

  def publication_date_filter?
    params[:starting_year].present? || params[:ending_year].present?
  end

  def filter_on_publication_date
    if is_a_year? params[:starting_year]
      # from beginning of start year
      starting_date = params[:starting_year] + "-01-01"
      @sorns = @sorns.where('publication_date::DATE > ?', starting_date)
    end

    if is_a_year? params[:ending_year]
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
    # postgres is giving us matches where any search word is returned. We want only exact matches.
    ilikes_sql = @fields_to_search.map{ |field| "#{field} ILIKE :search"}.join(" OR ")
    @sorns = @sorns.where(ilikes_sql, search: "%#{params[:search]}%")
  end

  def is_a_year?(user_entered_date)
    # ignore user entered dates that aren't a year. Our html doesn't allow these submissions either.
    user_entered_date.present? && user_entered_date.match(/^\d{4}$/)
  end

  def add_mentions_and_pagination
    # only need to load mentioned and pagination for html
    @sorns = @sorns.includes(:mentioned)
    @sorns = @sorns.page(params[:page])
  end

  def create_csv_from_current_search
    send_data @sorns.to_csv(@fields_to_search.map(&:to_s)), filename: "sorns-#{Date.today.to_s}.csv"
  end
end
