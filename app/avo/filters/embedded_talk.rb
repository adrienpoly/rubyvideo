# frozen_string_literal: true

class Avo::Filters::EmbeddedTalk < Avo::Filters::BooleanFilter
  self.name = "Embedded Talk"

  def apply(request, query, values)
    if values["external"]
      query = query.where(embedded: false)
    elsif values["embedded"]
      query = query.where(embedded: true)
    end

    query
  end

  def options
    {
      external: "External Link",
      embedded: "Embedded Talk"
    }
  end
end
