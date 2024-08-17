class Avo::Resources::Event < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.find_by(slug: id)
    end
  }

  def fields
    field :id, as: :id
    field :name, as: :text, link_to_record: true
    field :date, as: :date, hide_on: :index
    field :city, as: :text, hide_on: :index
    field :country_code, as: :text
    field :slug, as: :text
    # field :suggestions, as: :has_many
    field :organisation, as: :belongs_to
    field :talks, as: :has_many
    field :speakers, as: :has_many, through: :talks
    field :topics, as: :has_many
  end
end
