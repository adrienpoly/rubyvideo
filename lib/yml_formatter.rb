# require "psych"
require "psych/comments"

module YmlFormatter
  extend self

  def normalize_comment_lines(yaml_content)
    ast = Psych::Comments.parse_stream(escape_unicode(yaml_content))
    document = ast.children.first

    talks_sequence = document.root.children

    talks_sequence.each do |talk|
      if talk.leading_comments.size.positive?
        talk.leading_comments = talk.leading_comments.unshift("#") unless talk.leading_comments.first.strip == "#"
        talk.leading_comments = talk.leading_comments.push("#") unless talk.leading_comments.last.strip == "#"
      end
    end
    unescape_unicode(Psych::Comments.emit_yaml(ast))
  end

  def normalize_commented_yaml_file(yaml_content)
    ast = Psych::Comments.parse_stream(escape_unicode(yaml_content))
    document = ast.children.first

    talks_sequence = document.root.children

    talks_sequence.each do |talk|
      next unless talk.is_a?(Psych::Nodes::Mapping)

      # Iterate over the children of the mapping node in pairs (key, value)
      talk.children.each_slice(2).with_index do |(key_node, value_node), index|
        next unless value_node.is_a?(Psych::Nodes::Scalar)
        next if value_node.value.blank?
        # normalize the description field
        #
        # expected output ->
        # description: |-
        #   the multi line description
        #   of the talk
        #
        if key_node.value == "description"
          value_node.plain = false
          value_node.quoted = true
          value_node.style = Psych::Nodes::Scalar::LITERAL # Use literal style for block scalar
          value_node.value = value_node.value.gsub(" \n", "\n")

          # remove only trailing newlines at the end of the entire text
          # while preserving internal line breaks
          value_node.value = value_node.value.sub(/\n+\z/, "")
          value_node.start_line = key_node.start_line + 1
          value_node.start_column = key_node.start_column + 2
          value_node.end_line = 0
          value_node.end_column = 0
        end
      end
    end
    unescape_unicode(Psych::Comments.emit_yaml(ast))
  end

  def unescape_unicode(str)
    # Handle both \u{XXXX} and \UXXXXXXXX formats
    str = str.gsub(/\\u\{([\da-fA-F]+)\}/) { [$1.hex].pack("U") }
    str.gsub(/\\U([\da-fA-F]{8})/) { [$1.hex].pack("U") }
  end

  def escape_unicode(str)
    str.chars.map do |char|
      if emoji?(char)
        "\\U#{char.ord.to_s(16).rjust(8, "0")}"
      else
        char
      end
    end.join
  end

  # def emoji?(char)
  #   emoji_ranges = [
  #     "\u{1F600}".."\u{1F64F}", # Emoticons
  #     "\u{1F300}".."\u{1F5FF}", # Misc Symbols and Pictographs
  #     "\u{1F680}".."\u{1F6FF}", # Transport and Map
  #     "\u{2600}".."\u{26FF}",   # Misc symbols
  #     "\u{2700}".."\u{27BF}",   # Dingbats
  #     "\u{1F900}".."\u{1F9FF}", # Supplemental Symbols and Pictographs
  #     "\u{1FA70}".."\u{1FAFF}", # Symbols and Pictographs Extended-A
  #     "\u{1F1E6}".."\u{1F1FF}"  # Flags
  #   ]

  #   emoji_ranges.any? { |range| range.include?(char) }
  # end
  def emoji?(char)
    emoji_ranges = [
      "\u{1F600}-\u{1F64F}", # Emoticons
      "\u{1F300}-\u{1F5FF}", # Misc Symbols and Pictographs
      "\u{1F680}-\u{1F6FF}", # Transport and Map
      "\u{2600}-\u{26FF}",   # Misc symbols
      "\u{2700}-\u{27BF}",   # Dingbats
      "\u{1F900}-\u{1F9FF}", # Supplemental Symbols and Pictographs
      "\u{1FA70}-\u{1FAFF}", # Symbols and Pictographs Extended-A
      "\u{1F1E6}-\u{1F1FF}"  # Flags
    ]

    emoji_regex = Regexp.new("[#{emoji_ranges.join}]")

    char.match?(emoji_regex)
  end
end
