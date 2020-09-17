class SornXmlParser
  # Uses an XML streamer. Each method re-streams the file. Fast enough and uses no memory.

  def initialize(xml)
    @parser = Saxerator.parser(xml) {|config| config.ignore_namespaces!}
  end

  def parse_sorn
    {
      agency: get_agency,
      system_name_and_number: get_system_name_and_number,
      authority: get_authority,
      categories_of_record: get_categories_of_record
    }
  end

  def get_agency
    @parser.for_tag('AGENCY').first.to_s
  end

  def get_system_name_and_number
    expected_header = "SYSTEM NAME AND NUMBER:"
    name_and_number = get_text_after_header(expected_header)
    unless name_and_number
      expected_header = "System Name and Number:"
      name_and_number = get_text_after_header(expected_header)
    end

    return name_and_number
  end

  def get_authority
    expected_header = "AUTHORITY FOR MAINTENANCE OF THE SYSTEM:"
    authority = get_text_after_header(expected_header)
    unless authority
      expected_header = "AUTHORITY FOR THE MAINTENANCE OF THE SYSTEM:"
      authority = get_text_after_header(expected_header)
    end
    unless authority
      expected_header = "Authority for the System:"
      authority = get_text_after_header(expected_header)
    end

    return authority
  end

  def get_categories_of_record
    expected_header = "CATEGORIES OF RECORDS IN THE SYSTEM:"
    cor = get_text_after_header(expected_header)
    unless cor
      expected_header = "CATEGORIES OF RECORDS IN THE SYSTEM: "
      cor = get_text_after_header(expected_header)
    end

    return cor
  end

  private

  def get_text_after_header(expected_header)
    start_saving_text = false
    saved_text = []
    @parser.within('PRIACT').each do |node|
      if start_saving_text
        if node.name == 'HD' # stop at the next section header
          return saved_text.join.squish!
        end

        saved_text = saved_text << node
      end

      if node.class != Saxerator::Builder::StringElement
        node = node.flatten.join.squish!.to_s
      end

      if node.downcase == expected_header.downcase
        start_saving_text = true
        next
      end
    end
  end


  # def get_sorn_number
  #   expected_header = "SYSTEM NAME AND NUMBER:"
  #   name_and_number = get_text_after_header(expected_header)
  #   number = name_and_number.match(/(?<number>\w+\/\w+-\d+)/)[1]
  # end

  # def get_system_name
  #   expected_header = "SYSTEM NAME AND NUMBER:"
  #   name_and_number = get_text_after_header(expected_header)
  #   number = name_and_number.match(/(?<number>\w+\/\w+-\d+)/)[1]
  #   name = name_and_number.sub(number,'') # remove number
  #   name = name.sub(/^[\W]+/, '') # remove starting punctuation
  #   name = name.sub(/[\W]+$/, '') # remove ending punctuation
  # end

end
