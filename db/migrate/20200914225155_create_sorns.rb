class CreateSorns < ActiveRecord::Migration[6.0]
  def change
    create_table :sorns do |t|
      t.references :agency, null: false, foreign_key: true
      t.string :system_name_and_number
      t.string :authority
      t.string :categories_of_record
      t.boolean :a108
      t.string :xml_url

      t.timestamps
    end
  end
end
