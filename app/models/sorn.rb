include ActionView::Helpers::TextHelper

class Sorn < ApplicationRecord
  has_and_belongs_to_many :agencies

  include PgSearch::Model
  validates :citation, uniqueness: true

  scope :no_computer_matching, -> { where.not('action ILIKE ?', '%matching%') }

  default_scope { order(publication_date: :desc) }

  FIELDS = [
    :agency_names,
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
    :pdf_url,
    :citation,
    :title,
    :publication_date
  ]

  DEFAULT_FIELDS = [
    'agency_names',
    'action',
    'system_name',
    'summary',
    'html_url',
    'publication_date'
  ]

  pg_search_scope :dynamic_search, lambda { |field, query|
    {
      against: field,
      query: query
    }
  }

  def get_xml
    if xml_url.present? and xml.blank?
      response = HTTParty.get(self.xml_url, format: :plain)
      return nil unless response.success?
      self.update(xml: response.parsed_response)
    end
  end

  def parse_xml
    if xml.present?
      parsed_sorn = SornXmlParser.new(self.xml).parse_xml
      self.update(**parsed_sorn)
    end
  end

  def section_snippets(selected_fields, search_term)
    output = {}
    self.attributes.slice(*selected_fields).each do |key, value|
      if value =~ /#{search_term}/i
        output[key] = highlight(excerpt(value.to_s, search_term, radius: 200), search_term)
      end
    end
    output
  end

  def mentioned_sorns
    Sorn.where(id: mentioned) # loads all sorns mentioned
  end

  def get_mentioned_sorns
    return unless self.xml

    all_citations = self.xml.scan(/\d+\s+FR\s+\d+/) # get all FR citations
    mentioned_sorns = all_citations.filter_map do |citation| # find which of those are sorns
      child_sorn = Sorn.find_by(citation: citation)
    end

    mentioned_sorns.each do |child_sorn|
      add_parent_sorn_to_child_mentions(child_sorn)
      add_child_sorn_to_parent_mentions(child_sorn)
    end
  end

  def self.get_all_mentioned_sorns
    Sorn.in_batches.each_record(&:get_mentioned_sorns)
  end

  # https://prsanjay.wordpress.com/2015/07/15/export-to-csv-in-rails-select-columns-names-dynamically/
  def self.to_csv(columns = column_names, options = {})
    CSV.generate(**options) do |csv|
      csv.add_row columns
      all.each do |sorn|

        values = sorn.attributes.slice(*columns).values
        csv.add_row values
      end
    end
  end

  def linked
    Sorn.where(data_source: 'fedreg').where('history LIKE ?', '%' + self.citation + '%').first if self.citation
  end

  private

  def add_parent_sorn_to_child_mentions(child_sorn)
    return if child_sorn.mentioned.include? self.id.to_s

    child_sorn.mentioned.push(self.id)
    child_sorn.save
  end

  def add_child_sorn_to_parent_mentions(child_sorn)
    return if self.mentioned.include? child_sorn.id.to_s

    self.mentioned.push(child_sorn.id)
    self.save
  end
end
