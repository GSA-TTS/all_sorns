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
      @selected_agencies = params[:agencies].map(&:parameterize)
      @sorns = @sorns.joins(:agencies).where(agencies: {name: [params[:agencies]]}).distinct

    elsif search_and_fields_and_agency_present?
      # return matching, agency sorns with just those fields
      @selected_fields = params[:fields]
      @selected_agencies = params[:agencies].map(&:parameterize)
      field_syms = @selected_fields.map { |field| field.to_sym }
      @sorns = @sorns.joins(:agencies).where(agencies: {name: [params[:agencies]]}).distinct
      @sorns = @sorns.dynamic_search(field_syms, params[:search])

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

  def search_old
    search
  end


  # GET /sorns
  def index(source)
    if params[:search]
      redirect_to request.path if params[:search] == ''
      @sorns = Sorn.where(data_source: source).dynamic_search(Sorn::FIELDS, params[:search]).order(id: :asc)
    else
      @sorns = Sorn.where(data_source: source).order(id: :asc)
    end
    @count = @sorns.count
    @sorns = @sorns.page params[:page]
  end

  def table_everything
    index(:fedreg)
  end

  def table_important
    index(:fedreg)
  end

  def cards_everything
    index(:fedreg)
  end

  def cards_important
    index(:fedreg)
  end

  def systems
    index(:fedreg)
  end

  def bulk_table_everything
    index(:bulk)
  end

  def bulk_table_important
    index(:bulk)
  end

  def bulk_cards_everything
    index(:bulk)
  end

  def bulk_cards_important
    index(:bulk)
  end

  private

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
