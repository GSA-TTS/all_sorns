class AddSectionsToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :routine_uses, :string
    add_column :sorns, :retention, :string
    add_column :sorns, :exemptions, :string
  end
end
