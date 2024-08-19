class Avo::Filters::TopicTalks < Avo::Filters::BooleanFilter
  self.name = "Topic talks"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    return query if values["has_talks"] && values["no_talks"]

    if values["has_talks"]
      query = query.with_talks
    elsif values["no_talks"]
      query = query.without_talks
    end

    query
  end

  def options
    {
      has_talks: "With talk topics",
      no_talks: "Without talk topics"
    }
  end
end
