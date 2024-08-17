class Avo::Filters::Title < Avo::Filters::TextFilter
  self.name = "Title"
  self.button_label = "Filter by title (contains)"

  def apply(request, query, value)
    query.where("title LIKE ?", "%#{value}%")
  end
end
