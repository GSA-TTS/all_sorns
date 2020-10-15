class AddCitationIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :sorns, :citation
  end
end
