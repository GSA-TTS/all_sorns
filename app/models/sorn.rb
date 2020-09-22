class Sorn < ApplicationRecord
  belongs_to :agency
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: [
      :system_name_and_number,
      :authority,
      :action,
      :categories_of_record,
      :history
    ],
    associated_against: {
      agency: :name
    }
  # validates :system_name_and_number, uniqueness: true
end
