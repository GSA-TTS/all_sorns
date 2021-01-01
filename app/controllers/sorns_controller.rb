class SornsController < ApplicationController
  def search
    @sorns = Sorn.no_computer_matching.includes(:mentioned)

    if params[:fields].present?
      @selected_fields = params[:fields]
    else
      @selected_fields = Sorn::FIELDS.map &:to_s
    end

    if params[:search].present?
      if params[:fields] == Sorn::FIELDS.map(&:to_s)
        @sorns = @sorns.where('xml::TEXT ILIKE :search', search: "%#{params[:search]}%")
      else
        ilikes = @selected_fields.map do |field|
          "#{field} ILIKE :search"
        end
        @sorns = @sorns.where(ilikes.join(" OR "), search: "%#{params[:search]}%")
      end
    end

    if params[:agencies].present?
      @selected_agencies = params[:agencies].map(&:parameterize)
      @sorns = @sorns.joins(:agencies).where(agencies: {name: params[:agencies]})
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

    @sorns = @sorns.get_distinct

    @sorns = @sorns.page(params[:page]) if request.format == :html

    respond_to do |format|
      format.html
      # format.json { render json: @sorns.to_json }
      format.csv { send_data @sorns.to_csv(@selected_fields), filename: "sorns-#{Date.today.to_s}.csv" }
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
