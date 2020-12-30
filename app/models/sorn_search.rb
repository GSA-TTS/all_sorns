class SornSearch < ApplicationRecord
  self.primary_key = :sorn_id

  include PgSearch::Model
  pg_search_scope(
    :search,
    against: :tsv_document,
    using: {
      tsearch: {
        dictionary: 'english',
        tsvector_column: 'tsv_document',
      },
    },
  )
end