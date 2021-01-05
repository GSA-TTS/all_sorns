class SornsController < ApplicationController
  def search
    @sorns = Sorn.none.page(params[:page]) and return if params[:search].blank? # blank page on first visit

    @fields_to_search = params[:fields] || Sorn::FIELDS # use either selected fields or all of them
    @sorns = Sorn.no_computer_matching.dynamic_search(@fields_to_search, params[:search])

    if params[:agencies]
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
      # Matching on agencies could return duplicates, so get distinct
      @sorns = @sorns.get_distinct_with_dynamic_search_rank
    end

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

    @sorns = @sorns.only_exact_matches(params[:search], @fields_to_search) if multiword_search?

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

  def multiword_search?
    params[:search].scan(/\w+/).size > 1 if params[:search].present?
  end
<<<<<<< HEAD

  def no_params_on_page_load?
    params[:search].blank? && params[:fields].blank? && params[:agencies].blank?
  end

  def search_and_agency_blank?
    params[:search].blank? && params[:agencies].blank?
  end

  def search_present_and_agency_blank?
    params[:search].present? && params[:agencies].blank?
  end

  def search_blank_and_agency_present?
    params[:search].blank? && params[:agencies].present?
  end

  def search_and_fields_and_agency_present?
    params[:search].present? && params[:fields].present? && params[:agencies].present?
  end
end
=======
end
>>>>>>> c1cb7fb1f729c819a9a55eaf0bf105a33478e864
