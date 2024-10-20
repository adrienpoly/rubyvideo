class Avo::Resources::Speaker < Avo::BaseResource
  self.includes = []
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.find_by(slug: id)
    end
  }
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, link_to_record: true
    field :name, as: :text, link_to_record: true, sortable: true
    field :twitter, as: :text
    field :github, as: :text
    field :speakerdeck, as: :text
    field :bio, as: :textarea, hide_on: :index
    field :website, as: :text, hide_on: :index
    field :slug, as: :text, hide_on: :index
    field :talks_count, as: :number, sortable: true
    # field :suggestions, as: :has_many
    # field :speaker_talks, as: :has_many
    field :talks, as: :has_many, use_resource: "Avo::Resources::Talk"
  end

  def filters
    filter Avo::Filters::Name
    filter Avo::Filters::Slug
    filter Avo::Filters::Github
  end

  def actions
    action Avo::Actions::SpeakerGithub
    action Avo::Actions::AssignCanonicalSpeaker
  end
end
