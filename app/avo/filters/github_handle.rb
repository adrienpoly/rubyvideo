class Avo::Filters::GitHubHandle < Avo::Filters::TextFilter
  self.name = "GitHub handle (contains)"

  def apply(request, query, value)
    query.where("github LIKE ?", "%#{value}%")
  end
end
