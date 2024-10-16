class Avo::Filters::WithoutTalks < Avo::Filters::BooleanFilter
  self.name = "Without talks"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    if values["no_talks"]
      query = query.without_talks
    end

    query
  end

  def options
    {
      no_talks: "Without talks"
    }
  end
end
