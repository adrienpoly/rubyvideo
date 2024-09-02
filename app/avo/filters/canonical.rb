class Avo::Filters::Canonical < Avo::Filters::BooleanFilter
  self.name = "Canonical"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    return query if values["has_canonical"] && values["no_canonical"]
    if values["has_canonical"]
      query = query.with_canonical
    elsif values["no_canonical"]
      query = query.without_canonical
    end
    query
  end

  def options
    {
      has_canonical: "Has canonical",
      no_canonical: "Without canonical"
    }
  end
end
