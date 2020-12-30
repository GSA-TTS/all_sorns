class CreateSornSearches < ActiveRecord::Migration[6.0]
  def change
    create_view :sorn_searches, materialized: true

    add_index :sorn_searches, :tsv_document, using: :gin
  end
end
