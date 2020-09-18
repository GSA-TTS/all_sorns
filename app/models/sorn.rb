class Sorn < ApplicationRecord
  belongs_to :agency
  include PgSearch::Model
  pg_search_scope :search_by_categories_of_record, against: :categories_of_record
  # validates :system_name_and_number, uniqueness: true
end
