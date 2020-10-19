module SornsHelper

  def checked_by_default(field)
    "checked" if [:agency_names, :action, :system_name, :authority, :categories_of_record].include? field
  end
end
