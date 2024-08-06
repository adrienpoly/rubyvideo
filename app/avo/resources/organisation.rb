class Avo::Resources::Organisation < Avo::BaseResource
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
    field :description, as: :textarea, hide_on: :index
    field :website, as: :text
    field :language, as: :text
    field :kind, as: :select, enum: ::Organisation.kinds
    field :frequency, as: :select, enum: ::Organisation.frequencies, hide_on: :index
    field :youtube_channel_id, as: :text, hide_on: :index
    field :youtube_channel_name, as: :text, hide_on: :index
    field :slug, as: :text, hide_on: :index
    field :twitter, as: :text, hide_on: :index
    # field :suggestions, as: :has_many
    field :events, as: :has_many
    field :talks, as: :has_many, through: :events
  end
end
