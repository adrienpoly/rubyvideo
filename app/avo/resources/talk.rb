class Avo::Resources::Talk < Avo::BaseResource
  self.includes = [:event, :speakers, :topics]
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.find_by(slug: id)
    end
  }
  self.keep_filters_panel_open = true

  self.search = {
    query: -> { query.where(id: Talk.search(params[:q]).map(&:id)) }
  }

  def fields
    field :id, as: :id
    field :title, as: :text, link_to_record: true, sortable: true
    field :event, as: :belongs_to

    field :speaker_tags, for_attribute: :speakers, name: "Speakers", through: :speaker_talks, as: :tags, hide_on: [:show, :forms] do
      record.speakers.map(&:name)
    end

    field :topics, as: :tags, hide_on: [:index, :forms] do
      record.topics.map(&:name)
    end
    field :updated_at, as: :date, sortable: true
    field :slides_url, as: :text, hide_on: :index
    field :summary, as: :markdown, hide_on: :index
    field :has_raw_transcript, name: "Raw Transcript", as: :boolean do
      record.raw_transcript.present?
    end
    field :has_enhanced_transcript, name: "Enhanced Transcript", as: :boolean do
      record.enhanced_transcript.present?
    end
    field :has_summary, name: "Summary", as: :boolean do
      record.summary.present?
    end
    field :description, as: :textarea, hide_on: :index
    field :language, hide_on: :index
    field :slug, as: :text, hide_on: :index
    field :year, as: :number, hide_on: :index
    field :video_id, as: :text, hide_on: :index
    field :video_provider, as: :text, hide_on: :index
    field :thumbnail_xs, as: :external_image, hide_on: :index
    field :thumbnail_sm, as: :external_image, hide_on: :index
    field :thumbnail_md, as: :external_image, hide_on: :index
    field :thumbnail_lg, as: :external_image, hide_on: :index
    field :thumbnail_xl, as: :external_image, hide_on: :index
    field :date, as: :date, hide_on: :index
    field :like_count, as: :number, hide_on: :index
    field :view_count, as: :number, hide_on: :index
    field :created_at, as: :date, hide_on: :index
    field :updated_at, as: :date, sortable: true, filterable: true
    field :speakers, as: :has_many, through: :speaker_talks
    field :raw_transcript, as: :textarea, hide_on: :index, format_using: -> { value.to_text }, readonly: true
    field :enhanced_transcript, as: :textarea, hide_on: :index, format_using: -> { value.to_text }, readonly: true
    # field :suggestions, as: :has_many
    # field :speaker_talks, as: :has_many
  end

  def actions
    action Avo::Actions::Transcript
    action Avo::Actions::EnhanceTranscript
    action Avo::Actions::Summarize
    action Avo::Actions::ExtractTopics
    action Avo::Actions::UpdateFromYml
    action Avo::Actions::TalkIndex
  end

  def filters
    filter Avo::Filters::TalkEvent
    filter Avo::Filters::RawTranscript
    filter Avo::Filters::EnhancedTranscript
    filter Avo::Filters::Summary
    filter Avo::Filters::Topics
    filter Avo::Filters::Title
    filter Avo::Filters::Slug
    filter Avo::Filters::Language
  end
end
