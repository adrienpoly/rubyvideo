# require "psych"
require "psych/comments"

module YmlFormatter
  extend self

  def normalize_comment_lines(yaml_content)
    ast = Psych::Comments.parse_stream(yaml_content)
    document = ast.children.first

    talks_sequence = document.root.children

    talks_sequence.each do |talk|
      if talk.leading_comments.size.positive?
        talk.leading_comments = talk.leading_comments.unshift("#") unless talk.leading_comments.first.strip == "#"
        talk.leading_comments = talk.leading_comments.push("#") unless talk.leading_comments.last.strip == "#"
      end
    end
    Psych::Comments.emit_yaml(ast)
  end

  def normalize_commented_yaml_file(yaml_content)
    ast = Psych::Comments.parse_stream(yaml_content)
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
    Psych::Comments.emit_yaml(ast)
  end
end
