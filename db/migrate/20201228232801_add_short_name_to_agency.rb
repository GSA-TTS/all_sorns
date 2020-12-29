class AddShortNameToAgency < ActiveRecord::Migration[6.0]
  def change
    add_column :agencies, :short_name, :string
  end
end
