class Sorn < ApplicationRecord
  belongs_to :agency
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: [
      :system_name,
      :system_number,
      :authority,
      :purpose,
      :action,
      :categories_of_record,
      :history
    ],
    associated_against: {
      agency: :name
    }

  def linked
    Sorn.where(data_source: 'fedreg').where('history LIKE ?', '%' + self.citation + '%').first
  end

  def split_categories
    if self.categories_of_record
      JSON.parse(self.categories_of_record).map do |categories|
        categories.split ';'
      end.flatten.reject(&:empty?)
    end
  end
end
