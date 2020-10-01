class AddDataSourceToAgency < ActiveRecord::Migration[6.0]
  def change
    add_column :agencies, :data_source, :string
  end
end
