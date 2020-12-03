class SornXmlParser
  # Uses an XML streamer. Each method re-streams the file. Fast enough and uses no memory.

  def initialize(xml)
    @parser = Saxerator.parser(xml)
    @sections = get_sections
  end

  def parse_xml
    { summary: find_tag('SUM'),
      addresses: find_tag('ADD'),
      further_info: find_tag('FURINF'),
      supplementary_info: get_supplementary_information,
      system_name: get_system_name,
      system_number: get_system_number,
      security: find_section('SECURITY'),
      location: find_section('LOCATION'),
      manager: find_section('MANAGER'),
      authority: find_section('AUTHORITY'),
      purpose: find_section('PURPOSE'),
      categories_of_individuals: find_section('INDIVIDUALS'),
      categories_of_record: find_section('CATEGORIES OF RECORDS'),
      source: find_section('SOURCE'),
      routine_uses: find_section('ROUTINE'),
      storage: find_section('STORAGE'),
      retrieval: find_section('RETRIEVAL'), #Retrievability
      retention: find_section('RETENTION'),
      safeguards: find_section('SAFEGUARDS'),
      access: find_section('ACCESS'),
      contesting: find_section('CONTESTING'),
      notification: find_section('NOTIFICATION'),
      exemptions: find_section('EXEMPTIONS'),
      history: find_section('HISTORY'),
      headers: @sections.keys }
  end

  def get_supplementary_information
    content = @parser.within('SUPLINF').filter_map { |node| node if wanted_parts_of_supplementary_information_tag(node) }
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

  def find_tag(tag)
    content = @parser.within(tag).filter_map do |node|
      cleanup_xml_element_to_string(node) if node.name == "P"
    end
    content = content.map{|paragraph| "<p>#{paragraph}</p>" } if content.length > 1
    content.join(" ")
  end

  def find_section(header)
    # Get a named section of the PRIACT tag
    # header of 'NUMBER' will match the section with key 'System Name and Number'
    matched_header = @sections.keys.find{ |key| key.upcase.include? header }
    @sections[matched_header]
  end

  private

  def get_sections
    # Gather the named sections of the PRIACT tag
    sections = {}
    current_header = nil
    @parser.within('PRIACT').each do |node|
      if node.name == 'HD'
        current_header = cleanup_xml_element_to_string(node)
        sections[current_header] = []
      elsif current_header.nil?
        next
      elsif node.name == 'P'
        # Skipping a few rare FTNT, NOTE, and EXTRACT tags
        # append cleaned strings
        sections[current_header] << cleanup_xml_element_to_string(node)
      end
    end

    # discard the rare nil keys
    sections.except!(nil)
    # Join array into a large string of paragraphs.
    sections.transform_values! do |values|
      values = values.map{|paragraph| "<p>#{paragraph}</p>" } if values.length > 1
      values.join(" ")
    end
  end

  def cleanup_xml_element_to_string(element)
    # recursively convert hashes and array down to a string
    element = xml_hash_to_string(element) if element.class == Saxerator::Builder::HashElement
    element = xml_array_to_string(element) if element.class.in? [Array, Saxerator::Builder::ArrayElement]
    element.strip if element.class.in? [String, Saxerator::Builder::StringElement]
  end

  def xml_hash_to_string(element)
    if element.fetch('P', nil).present?
      # Grab the paragraphs out of any hashes
      cleanup_xml_element_to_string(element.fetch('P', nil))
    else
      # A very few section headers have a hash with E
      cleanup_xml_element_to_string(element.fetch('E', nil))
    end
  end

  def xml_array_to_string(element)
    # Arrays can contain hashes and arrays
    # turn all the inside elements into strings then join on spaces
    element.map do |e|
      cleanup_xml_element_to_string(e)
    end.join(" ")
  end

  def wanted_parts_of_supplementary_information_tag(node)
    # We want P tags and any HD tags that aren't SUPPLEMENTARY
    # an example of why paragraphs only won't work
    # https://www.federalregister.gov/documents/full_text/xml/2020/10/13/2020-22534.xml
    node.name == 'P' || (node.name == 'HD' && node.exclude?('SUPPLEMENTARY'))
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
end
