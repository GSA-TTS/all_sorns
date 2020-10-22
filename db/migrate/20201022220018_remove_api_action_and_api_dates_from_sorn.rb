class RemoveApiActionAndApiDatesFromSorn < ActiveRecord::Migration[6.0]
  def change
    remove_column :sorns, :api_action, :string
    remove_column :sorns, :api_dates, :string
  end
end
