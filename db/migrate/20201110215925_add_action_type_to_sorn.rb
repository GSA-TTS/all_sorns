class AddActionTypeToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :action_type, :string
  end
end
