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
    content = @parser.within('SUPLINF').map{ |node| node unless unwanted_parts_of_suplinf(node) }
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

  def find_tag(tag)
    element = @parser.for_tag(tag).first
    cleanup_xml_element_to_string(element)
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
    sections.each{ |key, value| sections[key] = value.join(" ") }
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

  def unwanted_parts_of_suplinf(node)
    # custom to get everything but priact and sig
    # an example of why paragraphs only won't work
    # https://www.federalregister.gov/documents/full_text/xml/2020/10/13/2020-22534.xml
    (node.name == 'HD' && node.include?('SUPPLEMENTARY')) || node.name == 'PRIACT' || node.name == 'SIG'
  end
end
