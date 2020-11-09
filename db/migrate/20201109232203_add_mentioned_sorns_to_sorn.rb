class AddMentionedSornsToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :mentioned, :string, array: true, default: []
  end
end
