class Avo::Resources::Topic < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name
    field :description
  end

  def filters
    filter Avo::Filters::Name
  end
end
