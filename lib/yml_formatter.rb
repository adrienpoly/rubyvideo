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
          value_node.style = 4 # multiline |- style output
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

  def add_slug_to_talks(yaml_content, talks_slugs)
    ast = Psych::Comments.parse_stream(yaml_content)
    document = ast.children.first

    talks_sequence = document.root.children

    talks_sequence.each do |talk|
      next unless talk.is_a?(Psych::Nodes::Mapping)

      # Initialize variables to hold video_id and slug key position
      video_id = nil
      slug_position = nil

      # Iterate over the children of the mapping node in pairs (key, value)
      talk.children.each_slice(2).with_index do |(key_node, value_node), index|
        # Extract the video_id value
        if key_node.value == "video_id"
          video_id = value_node.value
        end

        # Check if the 'slug' key already exists
        if key_node.value == "slug"
          slug_position = index * 2
        end
      end

      # If video_id is found and a corresponding slug exists in the hash
      if video_id && talks_slugs[video_id]
        slug_value = talks_slugs[video_id]

        if slug_position
          # Update the existing 'slug' value
          talk.children[slug_position + 1].value = slug_value
        else
          # Add a new 'slug' key-value pair
          slug_key_node = Psych::Nodes::Scalar.new("slug")
          slug_value_node = Psych::Nodes::Scalar.new(slug_value)

          # Insert the new 'slug' pair after the 'video_id' pair
          video_id_index = talk.children.index { |node| node.is_a?(Psych::Nodes::Scalar) && node.value == "video_id" }
          if video_id_index
            talk.children.insert(video_id_index + 2, slug_key_node, slug_value_node)
          end
        end
      end
    end
    Psych::Comments.emit_yaml(ast)
  end
end
