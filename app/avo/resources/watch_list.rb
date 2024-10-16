class Avo::Resources::WatchList < Avo::BaseResource
  self.title = :name
  self.includes = []

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :user, as: :belongs_to
    field :talks, as: :has_many, through: :watch_list_talks
  end
end
