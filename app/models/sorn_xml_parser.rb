class SornXmlParser
  # Uses an XML streamer. Each method re-streams the file. Fast enough and uses no memory.

  def initialize(xml)
    @parser = Saxerator.parser(xml) {|config| config.ignore_namespaces!}
  end

  def parse_sorn
    {
      agency: get_agency,
      action: get_action,
      system_name_and_number: get_system_name_and_number,
      authority: get_authority,
      categories_of_record: get_categories_of_record,
      history: get_history
    }
  end

  def get_agency
    @parser.for_tag('AGENCY').first.to_s
  end

  def get_action
    @parser.for_tag('ACT').first['P']
  end

  def get_system_name_and_number
    expected_header = ["SYSTEM NAME AND NUMBER:", "SYSTEM NAME AND NUMBER", "SYSTEM NAME:", "SYSTEM NAMES AND NUMBERS:"]
    get_text_after_header(expected_header)
  end

  def get_authority
    expected_header = ["AUTHORITY FOR MAINTENANCE OF THE SYSTEM:", "AUTHORITY FOR THE MAINTENANCE OF THE SYSTEM:", "Authority for the System:"]
    get_text_after_header(expected_header)
  end

  def get_categories_of_record
    expected_header = ["CATEGORIES OF RECORDS IN THE SYSTEM:"]
    get_text_after_header(expected_header)
  end

  def get_history
    expected_header = ["HISTORY:", "HISTORY"]
    get_text_after_header(expected_header)
  end

  private

  def get_text_after_header(expected_header)
    start_saving_text = false
    saved_text = []
    @parser.within('PRIACT').each do |node|
      if start_saving_text
        if node.name == 'HD' # stop at the next section header
          if node.exclude? 'HISTORY' # History is last section, no HD after it
            return saved_text.join.squish!
          end
        end

        saved_text = saved_text << node
      end

      if node.class != Saxerator::Builder::StringElement
        node = node.flatten.join.squish!.to_s
      end

      if expected_header.any? { |header| header.downcase.strip == node.downcase }
        start_saving_text = true
        next
      end
    end

    # If we didn't return any saved text, do it here. Useful for HISTORY section.
    return saved_text.join.squish!
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
