class AddSystemNumberToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :system_number, :string
    rename_column :sorns, :system_name_and_number, :system_name
  end
end
