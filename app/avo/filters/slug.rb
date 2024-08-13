class Avo::Filters::Slug < Avo::Filters::TextFilter
  self.name = "Slug"
  self.button_label = "Filter by slug (contains)"

  def apply(request, query, value)
    query.where("slug LIKE ?", "%#{value}%")
  end
end
