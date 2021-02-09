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

  def browse_all_link_text
    if params[:agencies].present? || params[:starting_year].present? || params[:starting_year].present?
      "Browse all SORNs with below filters >"
    else
      "Browse all SORNs >"
    end
  end

  def browse_mode_params
    browse = {
      "all-sorns": true
    }
    # Add any other filters to the url
    if @fields_to_search != Sorn::FIELDS
      browse[:fields] =  @fields_to_search
    end
    if params[:agencies].present?
      browse[:agencies] = params[:agencies]
    end
    if params[:starting_year].present?
      browse[:starting_year] = params[:starting_year]
    end
    if params[:starting_year].present?
      browse[:ending_year] = params[:ending_year]
    end
    browse
  end
end
