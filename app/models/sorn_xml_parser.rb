class SornXmlParser
  # Uses an XML streamer. Each method re-streams the file. Fast enough and uses no memory.

  def initialize(xml)
    @parser = Saxerator.parser(xml)
    @sections = get_sections
  end

  def parse_xml
    {
      summary: get_summary,
      addresses: get_addresses,
      further_info: get_further_information,
      supplementary_info: get_supplementary_information,
      system_name: get_system_name,
      system_number: get_system_number,
      security: get_security,
      location: get_location,
      manager: get_manager,
      authority: get_authority,
      purpose: get_purpose,
      categories_of_individuals: get_individuals,
      categories_of_record: get_categories_of_record,
      source: get_source,
      routine_uses: get_routine_uses,
      storage: get_storage,
      retrieval: get_retrieval,
      retention: get_retention,
      safeguards: get_safeguards,
      access: get_access,
      contesting: get_contesting,
      notification: get_notification,
      exemptions: get_exemptions,
      history: get_history,
      headers: @sections.keys
    }
  end

  def get_agency
    find_tag('AGENCY')
  end

  def get_summary
    find_tag('SUM')
  end

  def get_addresses
    find_tag('ADD')
  end

  def get_further_information
    find_tag('FURINF')
  end

  def get_supplementary_information
    # custom to get everything but priact and sig
    # an example of why paragraphs only won't work
    # https://www.federalregister.gov/documents/full_text/xml/2020/10/13/2020-22534.xml
    content = []
    @parser.within('SUPLINF').each do |node|
      if node.name != 'PRIACT' && node.name != 'SIG'
        # skip section title
        if node.name == 'HD' && node.include?('SUPPLEMENTARY')
          next
        else
          content << node
        end
      end
    end

    cleanup_xml_element_to_string(content)
  end

  def get_system_name
    @system_name = find_section('SYSTEM NAME')
  end

  def get_system_number
    number = find_section('NUMBER')
    # puts number
    if number and @system_name
      parse_system_name_from_number
    end
  end

  def parse_system_name_from_number
    digit_regex = Regexp.new('\d')
    if @system_name.match(digit_regex)
      precleaned = strip_known_patterns(@system_name)
      regex_captures = collect_regex_captures(precleaned)
      if regex_captures.length > 0
        cleaned_capture(regex_captures)
      end
    end
  end

  def strip_known_patterns(system_name)
    # This regex will strip the common pattern of a "(Month DD, YYY, Federal register citation)""
    no_cfr_syst_name = system_name.gsub(/\(\w+ \d\d\, \d{4}\, \d\d FR \d{4,6}\)/, '')
    # Remove references to the HSPD-12 PIV Card policy
    return no_cfr_syst_name.gsub(/HSPD-12/, '')
  end

  def collect_regex_captures(precleaned_system_name)
    regex_captures = []
    # Looks for a variety of common system number reference patterns that are either
    # just numbers or a combination of number and agency abbreviation system numbers
    generic_match = precleaned_system_name.match(/(\w+\/)?\w+(-| |.)\d+(-\d+)?/)
    if generic_match
      regex_captures.append(generic_match[0])
    end
    regex_captures
  end

  def cleaned_capture(capture_array)
    capture_array.delete('-')
    capture_array.uniq
    if capture_array.length > 0
      capture_array.join(', ')
    end
  end


  def get_security
    find_section('SECURITY')
  end

  def get_location
    find_section('LOCATION')
  end

  def get_manager
    find_section('MANAGER')
  end

  def get_authority
    find_section('AUTHORITY')
  end

  def get_purpose
    find_section('PURPOSE')
  end

  def get_individuals
    find_section('INDIVIDUALS')
  end

  def get_categories_of_record
    find_section('CATEGORIES OF RECORDS')
  end

  def get_source
    find_section('SOURCE')
  end

  def get_routine_uses
    find_section('ROUTINE')
  end

  def get_storage
    find_section('STORAGE')
  end

  def get_retrieval
    find_section('RETRIEVAL') #Retrievability
  end

  def get_retention
    find_section('RETENTION')
  end

  def get_safeguards
    find_section('SAFEGUARDS')
  end

  def get_access
    find_section('ACCESS')
  end

  def get_contesting
    find_section('CONTESTING')
  end

  def get_notification
    find_section('NOTIFICATION')
  end

  def get_exemptions
    find_section('EXEMPTIONS')
  end

  def get_history
    find_section('HISTORY')
  end

  def find_tag(tag)
    element = @parser.for_tag(tag).first
    cleanup_xml_element_to_string(element)
  end

  def find_section(header)
    # header of 'NUMBER' will match the section with key 'System Name and Number'
    matched_header = @sections.keys.find{ |key| key.upcase.include? header }
    @sections[matched_header]
  end

  private

  def get_sections
    sections = {}
    header = nil
    @parser.within('PRIACT').each do |node|
      if node.name == 'HD'
        header = cleanup_xml_element_to_string(node)
        next if header.nil? # a very few empty hashes
        sections[header] = []
      else
        # append clean strings, once we've found the first header
        sections[header] << cleanup_xml_element_to_string(node) if header.present?
      end
    end

    # Clean values from arrays to strings
    sections.keys.each do |header|
      sections[header] = sections[header].join " "
    end

    sections
  end

  def cleanup_xml_element_to_string(element)
    # The class is never a plain Hash
    if element.class == Saxerator::Builder::HashElement
      if element.fetch('P', nil).nil?
        # A very few section headers have a hash with E
        element = cleanup_xml_element_to_string(element.fetch('E', nil))
      else
        # Grab the paragraphs out of any hashes
        element = cleanup_xml_element_to_string(element.fetch('P', nil))
      end
    end

    # Arrays can be full of all the types
    # turn all the inside elements into strings
    # then join on spaces
    if element.class.in? [Array, Saxerator::Builder::ArrayElement]
      element = element.map do |e|
        cleanup_xml_element_to_string(e)
      end.join(" ")
    end

    # Return a stripped string
    element.strip if element.class.in? [String, Saxerator::Builder::StringElement]
  end
end
