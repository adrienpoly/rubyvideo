class Avo::Resources::Speaker < Avo::BaseResource
  self.includes = []
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.find_by(slug: id)
    end
  }
  self.search = {
    query: -> { query.where("lower(name) LIKE ?", "%#{params[:q].downcase}%") }
  }

  def fields
    field :id, as: :id, link_to_record: true
    field :name, as: :text, link_to_record: true, sortable: true
    field :twitter, as: :text
    field :github, as: :text
    field :speakerdeck, as: :text
    field :mastodon, as: :text, hide_on: :index
    field :linkedin, as: :text, hide_on: :index
    field :bsky, as: :text, hide_on: :index
    field :bio, as: :textarea, hide_on: :index
    field :website, as: :text, hide_on: :index
    field :slug, as: :text, hide_on: :index
    field :talks_count, as: :number, sortable: true
    field :canonical, as: :belongs_to, hide_on: :index
    # field :suggestions, as: :has_many
    # field :speaker_talks, as: :has_many
    field :talks, as: :has_many, use_resource: "Avo::Resources::Talk", attach_scope: -> { query.order(title: :asc) }, searchable: true
  end

  def filters
    filter Avo::Filters::Name
    filter Avo::Filters::Slug
    filter Avo::Filters::GitHub
  end

  def actions
    action Avo::Actions::SpeakerGitHub
    action Avo::Actions::AssignCanonicalSpeaker
  end
end
