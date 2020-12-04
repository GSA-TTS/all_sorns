class RemoveAgencyNamesFromSorn < ActiveRecord::Migration[6.0]
  def change
    remove_column :sorns, :agency_names, :string
  end
end
