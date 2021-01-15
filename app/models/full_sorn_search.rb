class FullSornSearch < ApplicationRecord
  self.primary_key = :sorn_id

  include PgSearch::Model
  pg_search_scope(
    :search,
    against: :full_sorn_tsvector,
    using: {
      tsearch: {
        dictionary: 'english',
        followed_by: true,
        tsvector_column: 'full_sorn_tsvector',
      },
    },
  )

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end