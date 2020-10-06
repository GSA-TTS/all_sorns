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

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['agency_name', 'system_name', 'authority', 'categories_of_record', 'xml_url']

      all.each do |sorn|
        csv << [sorn.agency.name, sorn.system_name, sorn.authority, sorn.categories_of_record, sorn.xml_url]
      end
    end
  end


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
