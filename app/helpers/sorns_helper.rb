module SornsHelper
  def field_selected?(field)
    params[:fields]&.include?(field)
  end

  def agency_selected?(agency_name)
    params[:agencies]&.include?(agency_name)
  end

  def csv_params
    { search: params[:search],
      fields: @fields_to_search,
      agencies: params[:agencies],
      starting_year: params[:starting_year],
      ending_year: params[:ending_year],
      format: :csv
    }
  end
end
