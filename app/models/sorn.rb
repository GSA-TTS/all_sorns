class Sorn < ApplicationRecord
  belongs_to :agency
  include PgSearch::Model

  FIELDS = [
    :action,
    :summary,
    :dates,
    :addresses,
    :further_info,
    :supplementary_info,
    :system_name,
    :system_number,
    :security,
    :location,
    :manager,
    :authority,
    :purpose,
    :categories_of_individuals,
    :categories_of_record,
    :source,
    :routine_uses,
    :storage,
    :retrieval,
    :retention,
    :safeguards,
    :access,
    :contesting,
    :notification,
    :exemptions,
    :history
  ]

  METADATA = [
    :html_url,
    :xml_url,
    :headers,
    :data_source,
    :citation
  ]

  pg_search_scope :dynamic_search, lambda { |field, query|
    {
      against: field,
      query: query
    }
  }

  pg_search_scope :search_by_all,
    against: FIELDS,
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
    Sorn.where(data_source: 'fedreg').where('history LIKE ?', '%' + self.citation + '%').first if self.citation
  end

  def split_categories
    if self.categories_of_record
      JSON.parse(self.categories_of_record).map do |categories|
        categories.split ';'
      end.flatten.reject(&:empty?)
    end
  end
end
