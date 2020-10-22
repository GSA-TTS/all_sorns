module SornsHelper
  def show_field?(field)
    default_while_no_search = params[:fields].nil? && Sorn::DEFAULT_FIELDS.include?(field)
    field_included = params[:fields].include?(field) if params[:fields]
    default_while_no_search || field_included
  end
end
