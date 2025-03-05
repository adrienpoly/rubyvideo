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

  def normalize_commented_yaml_file(file_path)
  end
end
