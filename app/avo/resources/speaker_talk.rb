class Avo::Resources::SpeakerTalk < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :speaker, as: :belongs_to, hide_on: :forms
    field :talk, as: :belongs_to, hide_on: :forms
    field :discarded_at, as: :date_time
  end
end
