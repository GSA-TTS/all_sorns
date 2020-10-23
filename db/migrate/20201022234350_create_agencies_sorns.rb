class CreateAgenciesSorns < ActiveRecord::Migration[6.0]
  def change
    create_table :agencies_sorns do |t|
      t.belongs_to :agency
      t.belongs_to :sorn
    end
  end
end
