# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talks
#
#  id                  :integer          not null, primary key
#  title               :string           default(""), not null
#  description         :text             default(""), not null
#  slug                :string           default(""), not null
#  video_id            :string           default(""), not null
#  video_provider      :string           default(""), not null
#  thumbnail_sm        :string           default(""), not null
#  thumbnail_md        :string           default(""), not null
#  thumbnail_lg        :string           default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  event_id            :integer
#  thumbnail_xs        :string           default(""), not null
#  thumbnail_xl        :string           default(""), not null
#  date                :date
#  like_count          :integer
#  view_count          :integer
#  raw_transcript      :text             default(""), not null
#  enhanced_transcript :text             default(""), not null
#  summary             :text             default(""), not null
#
# rubocop:enable Layout/LineLength
class Talk < ApplicationRecord
  extend ActiveJob::Performs
  include Talk::TranscriptCommands
  include Talk::SummaryCommands
  include Sluggable
  include Suggestable
  slug_from :title

  # include MeiliSearch
  include MeiliSearch::Rails
  ActiveRecord_Relation.include Pagy::Meilisearch
  extend Pagy::Meilisearch

  # associations
  belongs_to :event, optional: true
  has_many :speaker_talks, dependent: :destroy, inverse_of: :talk, foreign_key: :talk_id
  has_many :speakers, through: :speaker_talks, inverse_of: :talks

  has_many :talk_topics, dependent: :destroy
  has_many :topics, through: :talk_topics
  has_many :approved_topics, -> { approved }, through: :talk_topics, source: :topic, inverse_of: :talks

  # validations
  validates :title, presence: true
  validates :language, presence: true,
    inclusion: {in: Language.alpha2_codes, message: "%{value} is not a valid IS0-639 alpha2 code"}

  # delegates
  delegate :name, to: :event, prefix: true, allow_nil: true

  # jobs
  performs :update_from_yml_metadata!, queue_as: :low

  # normalization
  normalizes :language, apply_to_nil: true, with: ->(language) do
    language.present? ? Language.find(language)&.alpha2 : Language::DEFAULT
  end

  # TODO convert to performs
  def analyze_talk_topics!
    AnalyzeTalkTopicsJob.perform_now(self)
  end

  # search
  meilisearch do
    attribute :title
    attribute :description
    attribute :summary
    attribute :speaker_names do
      speakers.pluck(:name)
    end
    attribute :event_name do
      event_name
    end

    searchable_attributes [:title, :description, :speaker_names, :event_name, :summary]
    sortable_attributes [:title]

    attributes_to_highlight ["*"]
  end

  meilisearch enqueue: true

  # ensure that during the reindex process the associated records are eager loaded
  scope :meilisearch_import, -> { includes(:speakers, :event) }
  scope :without_raw_transcript, -> { where("raw_transcript IS NULL OR raw_transcript = '' OR raw_transcript = '[]'") }
  scope :with_raw_transcript, -> { where("raw_transcript IS NOT NULL AND raw_transcript != '[]'") }
  scope :without_enhanced_transcript, \
    -> { where("enhanced_transcript IS NULL OR enhanced_transcript = '' OR enhanced_transcript = '[]'") }
  scope :with_enhanced_transcript, -> { where("enhanced_transcript IS NOT NULL AND enhanced_transcript != '[]'") }
  scope :with_summary, -> { where("summary IS NOT NULL AND summary != ''") }
  scope :without_summary, -> { where("summary IS NULL OR summary = ''") }
  scope :without_topics, -> { where.missing(:talk_topics) }
  scope :with_topics, -> { joins(:talk_topics) }

  def to_meta_tags
    {
      title: title,
      description: description,
      og: {
        title: title,
        type: :website,
        image: {
          _: thumbnail_lg,
          alt: title
        },
        description: description,
        site_name: "RubyVideo.dev"
      },
      twitter: {
        card: "summary_large_image",
        site: "adrienpoly",
        title: title,
        description: description,
        image: {
          src: thumbnail_lg
        }
      }
    }
  end

  def thumbnail_xs
    self[:thumbnail_xs].presence || "https://i.ytimg.com/vi/#{video_id}/default.jpg"
  end

  def thumbnail_sm
    self[:thumbnail_sm].presence || "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg"
  end

  def thumbnail_md
    self[:thumbnail_md].presence || "https://i.ytimg.com/vi/#{video_id}/hqdefault.jpg"
  end

  def thumbnail_lg
    self[:thumbnail_lg].presence || "https://i.ytimg.com/vi/#{video_id}/sddefault.jpg"
  end

  def thumbnail_xl
    self[:thumbnail_xl].presence || "https://i.ytimg.com/vi/#{video_id}/maxresdefault.jpg"
  end

  def related_talks(limit: 6)
    Talk.order("RANDOM()").excluding(self).limit(limit)
  end

  def transcript
    enhanced_transcript.presence || raw_transcript
  end

  def update_from_yml_metadata!
    self.title = static_metadata.title
    self.description = static_metadata.description
    self.language = static_metadata.language
    self.date = static_metadata.try(:date) || static_metadata.published_at
    save
  end

  def static_metadata
    Static::Video.find_by(video_id: video_id)
  end
end
