class Avo::Filters::Summary < Avo::Filters::BooleanFilter
  self.name = "Summary"

  def apply(request, query, values)
    return query if values["has_summary"] && values["no_summary"]

    if values["has_summary"]
      query = query.with_summary
    elsif values["no_summary"]
      query = query.without_summary
    end

    query
  end

  def options
    {
      has_summary: "With summary",
      no_summary: "Without summary"
    }
  end
end
