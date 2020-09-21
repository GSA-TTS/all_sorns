class AddHistoryToSorns < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :history, :string
  end
end
