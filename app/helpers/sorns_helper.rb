module SornsHelper
  def field_selected?(field)
    params[:fields]&.include?(field)
  end

  def agency_selected?(agency_name)
    params[:agencies]&.include?(agency_name)
  end
end
