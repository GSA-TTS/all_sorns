class SornsController < ApplicationController
  def search

    if !no_params_on_page_load?
      if dates_blank?
        puts 'holy cow'
      end
      # initialize on search first
      populate_parameters()
    end
  end

  private

  def populate_parameters
    
    @sorns = Sorn.no_computer_matching.includes(:mentioned).preload(:agencies)
    
    if params[:fields].blank? && dates_blank?
      initial_broad_search()

    elsif search_and_agency_blank?
      #  return all sorns with just those fields
      @selected_fields = params[:fields]

    elsif search_present_and_agency_blank?
      #  return matching sorns with just those fields
      @selected_fields = params[:fields]
      field_syms = @selected_fields.map { |field| field.to_sym }
      @sorns = @sorns.dynamic_search(field_syms, params[:search])

    elsif search_blank_and_agency_present?
      # return agency sorns with just those fields
      @selected_fields = params[:fields]
      @selected_agencies = params[:agencies].map(&:parameterize)
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
      @sorns = @sorns.get_distinct

    elsif search_and_fields_and_agency_present?
      # return matching, agency sorns with just those fields
      @selected_fields = params[:fields]
      @selected_agencies = params[:agencies].map(&:parameterize)
      field_syms = @selected_fields.map { |field| field.to_sym }
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
      @sorns = @sorns.dynamic_search(field_syms, params[:search])
      @sorns = @sorns.get_distinct_with_dynamic_search
    else
      raise "WUT"
    end

    if multiword_search?
      @sorns = @sorns.only_exact_matches(params[:search], @selected_fields)
      @sorns = Kaminari.paginate_array(@sorns).page(params[:page]) if request.format == :html
    else
      @sorns = @sorns.page(params[:page]) if request.format == :html
    end

    respond_to do |format|
      format.html
      # format.json { render json: @sorns.to_json }
      format.csv { send_data @sorns.to_csv(@selected_fields), filename: "sorns-#{Date.today.to_s}.csv" }
    end
  end

  def initial_broad_search
    # place where can optimize future initial searches
    @selected_fields = Sorn::FIELDS
    field_syms = @selected_fields.map { |field| field.to_sym }
    @sorns = @sorns.dynamic_search(field_syms, params[:search])
  end

  def date_filter
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
  end

  def multiword_search?
    params[:search].scan(/\w+/).size > 1 if params[:search].present?
  end

  def no_params_on_page_load?
    params[:search].blank? && params[:fields].blank? && params[:agencies].blank? && dates_blank?
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

  def dates_blank?
    (params[:starting_date].blank? || params[:ending_year].blank)
  end
end
