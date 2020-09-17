class Sorn < ApplicationRecord
  belongs_to :agency
  validates :system_name_and_number, uniqueness: true
end
