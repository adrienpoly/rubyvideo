module MarkdownHelper
  def markdown_to_html(markdown_content)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(markdown_content).html_safe
  end
end
