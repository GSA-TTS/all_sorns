class AddCitationToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :citation, :string
  end
end
