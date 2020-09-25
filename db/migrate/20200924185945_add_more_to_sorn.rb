class AddMoreToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :purpose, :string
  end
end
