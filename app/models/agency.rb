class Agency < ApplicationRecord
  has_and_belongs_to_many :sorns
  default_scope { order(name: :asc) }
end
