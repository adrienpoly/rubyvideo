class Avo::Resources::TalkTopic < Avo::BaseResource
  self.includes = [:talk, :topic]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :talk_title, as: :text do
      record.talk.title
    end
    field :topic_name, as: :text do
      record.topic.name
    end
  end
end
