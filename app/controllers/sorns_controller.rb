class SornsController < ApplicationController
  def search
    if params[:search]
      @sorns = @sorns.dynamic_search(@selected_fields, params[:search]).get_distinct_with_dynamic_search
    else
      @sorns = Sorn.none.page(params[:page]) and return # blank page on first visit
    end

    @sorns = Sorn.no_computer_matching.includes(:mentioned)# .preload(:agencies)
    @selected_fields = params[:fields] || Sorn::FIELDS

    if params[:agencies]
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
      @selected_agencies = params[:agencies].map(&:parameterize)
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


    if multiword_search?
      @sorns = @sorns.only_exact_matches(params[:search], @selected_fields) if request.format == :html
      @sorns = Kaminari.paginate_array(@sorns).page(params[:page]) if request.format == :html
    else
      @sorns = @sorns.page(params[:page]) if request.format == :html
    end

    respond_to do |format|
      format.html
      format.csv { send_data @sorns.to_csv(@selected_fields.map(&:to_s)), filename: "sorns-#{Date.today.to_s}.csv" }
    end
  end

  private

  def multiword_search?
    params[:search].scan(/\w+/).size > 1 if params[:search].present?
  end

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
