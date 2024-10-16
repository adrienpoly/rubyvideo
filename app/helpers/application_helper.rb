module ApplicationHelper
  include Pagy::Frontend

  def back_path
    @back_path || root_path
  end

  def footer_credits
    output = ["Made with"]
    output << heroicon(:heart, variant: :solid, size: :sm, class: "text-primary inline")
    output << "for the Ruby community by"
    output << link_to("@adrienpoly", "https://www.adrienpoly.com", target: "_blank", class: "link", alt: "Adrien Poly Ruby on Rails developer / CTO")
    output << "and wonderful"
    output << link_to("contributors", "https://github.com/adrienpoly/rubyvideo/graphs/contributors", target: "_blank", class: "link")
    output << "using an"
    output << link_to("edge stack.", uses_path, class: "link")
    sanitize(output.join(" "), tags: %w[a span svg path], attributes: %w[href target class alt d xmlns viewBox fill])
  end

  def canonical_url
    content_for?(:canonical_url) ? content_for(:canonical_url) : "https://www.rubyvideo.dev#{request.path}"
  end
end
