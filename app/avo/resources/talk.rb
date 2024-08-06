class Avo::Resources::Talk < Avo::BaseResource
  self.includes = [:event]
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
    field :id, as: :id
    field :title, as: :text, link_to_record: true
    field :summary, as: :markdown, hide_on: :index
    field :description, as: :textarea, hide_on: :index
    field :slug, as: :text, hide_on: :index
    field :video_id, as: :text, hide_on: :index
    field :video_provider, as: :text, hide_on: :index
    field :thumbnail_sm, as: :text, hide_on: :index
    field :thumbnail_md, as: :text, hide_on: :index
    field :thumbnail_lg, as: :text, hide_on: :index
    field :year, as: :number
    field :thumbnail_xs, as: :text, hide_on: :index
    field :thumbnail_xl, as: :text, hide_on: :index
    field :date, as: :date, hide_on: :index
    field :like_count, as: :number
    field :view_count, as: :number, hide_on: :index
    field :raw_transcript, as: :textarea, hide_on: :index, format_using: -> { value.to_vtt }, readonly: true
    field :enhanced_transcript, as: :textarea, hide_on: :index, format_using: -> { value.to_vtt }, readonly: true
    # field :suggestions, as: :has_many
    field :event, as: :belongs_to
    # field :speaker_talks, as: :has_many
    field :speakers, as: :has_many, through: :speaker_talks
  end
end
