class AddHeadersToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :headers, :string
  end
end
