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
    :publication_date,
    :action_type
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

  def get_action_type
    action_type = case self.action
    when /Recertif*/i, /renew*/i, /re-establish*/i, /republicat*/i
      "Renewal"
    when /match*/i
      "Computer Matching Agreement"
    when /modif*/i, /alter*/i, /new blanket routine use/i, /amend*/i, /revis*/i, /change/i, /updat*/i, /new routine use/i
      "Modification"
    when /rescind*/i, /delet*/i, /resciss*/i, /retir*/i, /withdraw*/i
      "Rescindment"
    when /exempt*/i
      "Exemption"
    when /new/i, "Notice of system of records.", "Notice of Privacy Act system of records.", /add/i, "Notice of Privacy Act System of Records.", "Notice of systems of records.", /propos*/i, "Notice of Systems of Records.", /public*/i
      'New'
    else
      "Unknown or Other"
    end

    self.update(action_type: action_type)
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
end
