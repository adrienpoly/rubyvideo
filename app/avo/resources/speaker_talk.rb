class Avo::Resources::SpeakerTalk < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :speaker_id, as: :number
    field :talk_id, as: :number
    field :speaker, as: :belongs_to
    field :talk, as: :belongs_to
  end
end
