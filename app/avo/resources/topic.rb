class Avo::Resources::Topic < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
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
    field :name, as: :text
    field :description, as: :markdown, hide_on: :index
    field :published, as: :boolean
    field :talks, as: :has_many
  end

  def actions
    action Avo::Actions::PublishTopic
  end

  def filters
    filter Avo::Filters::Name
    filter Avo::Filters::Published
  end
end
