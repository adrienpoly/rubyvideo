class Avo::Resources::User < Avo::BaseResource
  self.includes = []
  self.search = {
    query: -> { query.where(email: params[:q]) }
  }

  def fields
    field :id, as: :id, link_to_record: true
    field :email, as: :text, link_to_record: true
    field :name, as: :text, link_to_record: true
    field :admin, as: :boolean
    field :sessions, as: :has_many
    field :connected_accounts, as: :has_many
  end
end
