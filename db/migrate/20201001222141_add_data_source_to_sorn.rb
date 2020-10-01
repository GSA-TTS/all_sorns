class AddDataSourceToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :data_source, :string
  end
end
