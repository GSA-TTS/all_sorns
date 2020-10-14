class Sorn < ApplicationRecord
  belongs_to :agency
  include PgSearch::Model

  pg_search_scope :dynamic_search, lambda { |field, query|
    {
      against: field,
      query: query
    }
  }

  pg_search_scope :search_by_all,
    against: [
      :system_name,
      :authority,
      :action,
      :categories_of_record,
      :html_url,
      :xml_url,
      :history,
      :purpose,
      :routine_uses,
      :retention,
      :exemptions,
      :summary,
      :dates,
      :addresses,
      :further_info,
      :supplementary_info,
      :security,
      :location,
      :manager,
      :categories_of_individuals,
      :source,
      :storage,
      :retrieval,
      :safeguards,
      :access,
      :contesting,
      :notification,
      :headers,
      :system_number,
      :data_source,
      :citation
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
