include ActionView::Helpers::TextHelper

class Sorn < ApplicationRecord
  has_and_belongs_to_many :agencies
  has_and_belongs_to_many :mentioned, class_name: "Sorn", join_table: :mentions,
                          foreign_key: :sorn_id, association_foreign_key: :mentioned_sorn_id

  include PgSearch::Model
  validates :citation, uniqueness: true

  scope :no_computer_matching, -> { where.not('"sorns"."action" ILIKE ?', '%matching%') }
  scope :get_distinct, -> { select(:id, Sorn::FIELDS + Sorn::METADATA).distinct }
  scope :get_distinct_with_dynamic_search, -> { select(:id, Sorn::FIELDS + Sorn::METADATA,"#{PgSearch::Configuration.alias('sorns')}.rank").distinct }

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
    'categories_of_individuals',
    'categories_of_record',
    'html_url',
    'publication_date'
  ]

  pg_search_scope :dynamic_search, lambda { |field, query|
    {
      against: field,
      query: query,
      using: {
        tsearch: {
          highlight: {
            StartSel: '<b>',
            StopSel: '</b>',
            MaxWords: 123,
            MinWords: 456,
            ShortWord: 4,
            HighlightAll: true,
            MaxFragments: 3,
            FragmentDelimiter: '&hellip;'
          }
        }
      }
    }
  }

  def get_xml
    if xml_url.present? and xml.blank?
      sleep 1

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
      found = false
      search_term.split(" ").each do |search_word|
        found = true if value =~ /#{search_word}/i
      end
      if found == true
        output[key] = highlight(value, search_term.split(" "))
      end
    end
    output
  end

  def update_mentioned_sorns
    mentioned_sorns_in_xml.each do |child_sorn|
      self.mentioned << child_sorn if self.mentioned.exclude? child_sorn # add history to sorn
      child_sorn.mentioned << self if child_sorn.mentioned.exclude? self # add the future to sorn!
    end
  end

  def self.update_all_mentioned_sorns
    Sorn.in_batches.each_record(&:update_mentioned_sorns)
  end

  def self.parse_all_xml_again
    Sorn.in_batches.each_record(&:parse_xml)
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

  def mentioned_sorns_in_xml
    return [] unless self.xml

    all_citations = self.xml.scan(/\d+\s+FR\s+\d+/) # get all FR citations
    all_citations.filter_map do |citation| # find which of those are sorns
      Sorn.find_by(citation: citation)
    end
  end
end
