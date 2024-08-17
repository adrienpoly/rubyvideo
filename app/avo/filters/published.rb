class Avo::Filters::Published < Avo::Filters::BooleanFilter
  self.name = "Approved Status"

  def apply(request, query, values)
    selected_statuses = values.select { |k, v| v }.keys

    if selected_statuses.any?
      query = query.where(status: selected_statuses)
    end

    query
  end

  def options
    {
      pending: "Pending",
      approved: "Approved",
      rejected: "Rejected"
    }
  end
end
