module Handlers
  class MarkdownHandler
    def call(template, source)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      rendered_content = markdown.render(source)

      # Escape the rendered content to prevent string interpolation issues
      escaped_content = rendered_content.gsub('"', '\"').gsub("\n", "\\n")

      %(
        "<div class='container my-8 markdown'>#{escaped_content}</div>".html_safe
      )
    end
  end
end

ActionView::Template.register_template_handler :md, Handlers::MarkdownHandler.new
