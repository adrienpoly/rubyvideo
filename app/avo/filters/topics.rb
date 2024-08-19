class Avo::Filters::Topics < Avo::Filters::BooleanFilter
  self.name = "Topics"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    return query if values["has_topics"] && values["no_topics"]

    if values["has_topics"]
      query = query.with_topics
    elsif values["no_topics"]
      query = query.without_topics
    end

    query
  end

  def options
    {
      has_topics: "With topics",
      no_topics: "Without topics"
    }
  end
end
