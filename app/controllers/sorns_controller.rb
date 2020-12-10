class SornsController < ApplicationController
  def search
    @sorns = Sorn.no_computer_matching.includes(:mentioned).preload(:agencies)

    if no_params_on_page_load?
      # return all sorns with default fields
      @selected_fields = Sorn::DEFAULT_FIELDS

    elsif params[:fields].blank?
      # Return nothing, with no default fields
      @selected_fields = nil
      @sorns = Sorn.none

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
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agency]})

    elsif search_and_fields_and_agency_present?
      # return matching, agency sorns with just those fields
      @selected_fields = params[:fields]
      field_syms = @selected_fields.map { |field| field.to_sym }
      @sorns = @sorns.dynamic_search(field_syms, params[:search]).joins(:agencies).where(agencies: {name: params[:agency]})

    else
      raise "WUT"
    end

    @sorns = @sorns.page(params[:page]) if request.format == :html

    respond_to do |format|
      format.html
      # format.json { render json: @sorns.to_json }
      format.csv { send_data @sorns.to_csv(@selected_fields), filename: "sorns-#{Date.today.to_s}.csv" }
    end
  end

  private

  def no_params_on_page_load?
    params[:search].blank? && params[:fields].blank? && params[:agency].blank?
  end

  def search_and_agency_blank?
    params[:search].blank? && params[:agency].blank?
  end

  def search_present_and_agency_blank?
    params[:search].present? && params[:agency].blank?
  end

  def search_blank_and_agency_present?
    params[:search].blank? && params[:agency].present?
  end

  def search_and_fields_and_agency_present?
    params[:search].present? && params[:fields].present? && params[:agency].present?
  end
end
