class Avo::Filters::Published < Avo::Filters::BooleanFilter
  self.name = "Published"

  def apply(request, query, values)
    return query if values["published"] == values["unpublished"]

    if values["published"]
      query = query.where(published: true)
    elsif values["unpublished"]
      query = query.where(published: false)
    end
    query
  end

  def options
    {
      published: "Published",
      unpublished: "Unpublished"
    }
  end
end
