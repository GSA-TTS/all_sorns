class CreateAgency < ActiveRecord::Migration[6.0]
  def change
    create_table :agencies do |t|
      t.string :name
      t.integer :api_id, index: true
      t.integer :parent_api_id, index: true

      t.timestamps
    end
  end
end
