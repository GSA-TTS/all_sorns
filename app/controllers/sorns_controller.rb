class SornsController < ApplicationController
  def search


    if no_params_on_page_load?


      # return all sorns with default fields
      puts 'a'

    else
      populate_parameters()
    end
  end

  private

  def populate_parameters
    @selected_fields = Sorn::DEFAULT_FIELDS
    @sorns = Sorn.no_computer_matching.includes(:mentioned).preload(:agencies)
    
    if params[:fields].blank?
      # Return nothing, with no default fields
      @selected_fields = nil
      @sorns = Sorn.none
      puts 'b'

    elsif search_and_agency_blank?
      #  return all sorns with just those fields
      @selected_fields = params[:fields]
      puts 'c'

    elsif search_present_and_agency_blank?
      #  return matching sorns with just those fields
      @selected_fields = params[:fields]
      field_syms = @selected_fields.map { |field| field.to_sym }
      @sorns = @sorns.dynamic_search(field_syms, params[:search])
      puts 'd'

    elsif search_blank_and_agency_present?
      # return agency sorns with just those fields
      @selected_fields = params[:fields]
      @selected_agencies = params[:agencies].map(&:parameterize)
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
      @sorns = @sorns.get_distinct
      puts 'e'

    elsif search_and_fields_and_agency_present?
      # return matching, agency sorns with just those fields
      @selected_fields = params[:fields]
      @selected_agencies = params[:agencies].map(&:parameterize)
      field_syms = @selected_fields.map { |field| field.to_sym }
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
      @sorns = @sorns.dynamic_search(field_syms, params[:search])
      @sorns = @sorns.get_distinct_with_dynamic_search
      puts 'f'
    else
      raise "WUT"
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
