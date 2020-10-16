class DropAgencyTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :sorns, :agency_id, :references
    drop_table :agencies
    add_column :sorns, :agency_names, :string
  end
end
