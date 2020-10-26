class DropAgencyTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :sorns, :agency_id, :references
    drop_table :agencies
    add_column :sorns, :agency_names, :string
    execute "create index agency_names_idx on sorns using gist(to_tsvector('english', agency_names));"
  end
end
