class Avo::Filters::TopicTalks < Avo::Filters::BooleanFilter
  self.name = "Topic talks"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    return query if values["has_talks"] && values["no_talks"] && values["one_talk"] && values["two_talks"]

    if values["has_talks"]
      query = query.with_talks
    elsif values["no_talks"]
      query = query.without_talks
    elsif values["one_talk"]
      query = query.with_n_talk(1)
    elsif values["two_talks"]
      query = query.with_n_talk(2)
    end

    query
  end

  def options
    {
      has_talks: "With talk topics",
      no_talks: "Without talk topics",
      one_talk: "One talk",
      two_talks: "Two talks"
    }
  end
end
