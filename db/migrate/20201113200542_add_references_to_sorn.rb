class AddReferencesToSorn < ActiveRecord::Migration[6.0]
  def change
    remove_column :sorns, :mentioned, :string, array: true, default: []
    add_reference :sorns, :mentioned_in, index: true
  end
end
