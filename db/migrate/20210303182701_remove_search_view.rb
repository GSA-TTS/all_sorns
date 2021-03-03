class RemoveSearchView < ActiveRecord::Migration[6.0]
  def up
    remove_index :full_sorn_searches, :full_sorn_tsvector
    drop_view :full_sorn_searches, materialized: true
  end

  def down
    create_view :full_sorn_searches, materialized: true
    add_index :full_sorn_searches, :full_sorn_tsvector, using: :gin
  end
end
