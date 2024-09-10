class Avo::Resources::User < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, link_to_record: true
    field :email, as: :text, link_to_record: true
    field :first_name, as: :text, link_to_record: true
    field :last_name, as: :text, link_to_record: true
    # field :verified, as: :boolean
    field :admin, as: :boolean
    # field :sessions, as: :has_many, use_resource: Avo::Resources::Session
    field :sessions, as: :has_many
    field :connected_accounts, as: :has_many
  end
end
