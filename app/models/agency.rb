class Agency < ApplicationRecord
  has_many :sorns, dependent: :destroy
end
