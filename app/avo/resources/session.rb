class Avo::Resources::Session < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, link_to_record: true
    field :user_agent, as: :text, format_using: -> { value.truncate(50) }, only_on: :index
    field :user_agent, as: :text, hide_on: :index
    field :ip_address, as: :text
    field :user, as: :belongs_to, use_resource: Avo::Resources::User, link_to_record: true, hide_on: :index
  end
end
