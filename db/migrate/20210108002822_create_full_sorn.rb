class CreateFullSorn < ActiveRecord::Migration[6.0]
  def change
    create_view :full_sorn_searches, materialized: true

    add_index :full_sorn_searches, :full_sorn_tsvector, using: :gin
  end
end
