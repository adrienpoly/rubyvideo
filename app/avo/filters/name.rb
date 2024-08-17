class Avo::Filters::Name < Avo::Filters::TextFilter
  self.name = "Name"
  self.button_label = "Filter by name (contains)"

  def apply(request, query, value)
    query.where("name LIKE ?", "%#{value}%")
  end
end
