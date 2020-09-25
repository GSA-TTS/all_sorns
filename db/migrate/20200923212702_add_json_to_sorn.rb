class AddJsonToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :sections, :json
  end
end
