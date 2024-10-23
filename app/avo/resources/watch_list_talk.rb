class Avo::Resources::WatchListTalk < Avo::BaseResource
  self.includes = [:talk, :watch_list]

  def fields
    field :id, as: :id
    field :talk, as: :belongs_to
    field :watch_list, as: :belongs_to
    field :created_at, as: :date_time
  end
end
