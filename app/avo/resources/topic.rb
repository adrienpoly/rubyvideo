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
  self.keep_filters_panel_open = true

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :markdown, hide_on: :index
    field :status, as: :status, loading_when: "pending", success_when: "approved", failed_when: "rejected", hide_on: :forms
    field :status, as: :select, enum: ::Topic.statuses, only_on: :forms
    field :talks, as: :has_many
  end

  def actions
    action Avo::Actions::ApproveTopic
    action Avo::Actions::RejectTopic
  end

  def filters
    filter Avo::Filters::Name
    filter Avo::Filters::Published
    filter Avo::Filters::TopicTalks
  end
end
