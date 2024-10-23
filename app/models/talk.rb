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
#  raw_transcript      :text             default(#<Transcript:0x00000001645d16b8 @cues=[]>), not null
#  enhanced_transcript :text             default(#<Transcript:0x00000001645d15c8 @cues=[]>), not null
#  summary             :text             default(""), not null
#  language            :string           default("en"), not null
#
# rubocop:enable Layout/LineLength
class Talk < ApplicationRecord
  extend ActiveJob::Performs
  include Talk::TranscriptCommands
  include Talk::SummaryCommands
  include Sluggable
  include Suggestable
  include Searchable
  slug_from :title

  # include MeiliSearch
  # include MeiliSearch::Rails
  # ActiveRecord_Relation.include Pagy::Meilisearch
  # extend Pagy::Meilisearch

  # associations
  belongs_to :event, optional: true, counter_cache: :talks_count
  has_many :speaker_talks, dependent: :destroy, inverse_of: :talk, foreign_key: :talk_id
  has_many :speakers, through: :speaker_talks, inverse_of: :talks

  has_many :talk_topics, dependent: :destroy
  has_many :topics, through: :talk_topics
  has_many :approved_topics, -> { approved }, through: :talk_topics, source: :topic, inverse_of: :talks

  has_many :watch_list_talks, dependent: :destroy
  has_many :watch_lists, through: :watch_list_talks

  # validations
  validates :title, presence: true
  validates :language, presence: true,
    inclusion: {in: Language.alpha2_codes, message: "%{value} is not a valid IS0-639 alpha2 code"}

  # scopes
  scope :with_topics, -> { joins(:talk_topics) }
  scope :without_topics, -> { where.missing(:talk_topics) }

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
  # meilisearch do
  #   attribute :title
  #   attribute :description
  #   attribute :summary
  #   attribute :speaker_names do
  #     speakers.pluck(:name)
  #   end
  #   attribute :event_name do
  #     event_name
  #   end

  #   searchable_attributes [:title, :description, :speaker_names, :event_name, :summary]
  #   sortable_attributes [:title]

  #   attributes_to_highlight ["*"]
  # end

  # meilisearch enqueue: true

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

  scope :with_essential_card_data, -> do
    select(:id, :slug, :title, :date, :thumbnail_sm, :thumbnail_lg, :video_id, :event_id, :language)
      .includes(:speakers, :event)
  end

  def managed_by?(visiting_user)
    return false unless visiting_user.present?
    return true if visiting_user.admin?

    speakers.exists?(user: visiting_user)
  end

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
    ids = Rails.cache.fetch(["talk_recommendations", id, limit], expires_in: 1.week) do
      Talk.order("RANDOM()").excluding(self).limit(limit).ids
    end

    Talk.where(id: ids)
  end

  def transcript
    enhanced_transcript.presence || raw_transcript
  end

  def speaker_names
    speakers.pluck(:name).join(" ")
  end

  def slug_candidates
    [
      title.parameterize,
      [title.parameterize, event&.name&.parameterize].compact.join("-"),
      [title.parameterize, language.parameterize].compact.join("-"),
      [title.parameterize, event&.name&.parameterize, language.parameterize].compact.join("-"),
      [date.to_s.parameterize, title.parameterize].compact.join("-"),
      [title.parameterize, *speakers.map(&:slug)].compact.join("-"),
      [static_metadata.raw_title.parameterize].compact.join("-"),
      [date.to_s.parameterize, static_metadata.raw_title.parameterize].compact.join("-")
    ].uniq
  end

  def unused_slugs
    slug_candidates.reject { |slug| Talk.excluding(self).exists?(slug: slug) }
  end

  def update_from_yml_metadata!(event: nil)
    if event.blank?
      event = Event.find_by(name: static_metadata.event_name)

      if event.nil?
        puts "No event found! Video ID: #{video_id}, Event: #{static_metadata.event_name}"
        return
      end
    end

    if Array.wrap(static_metadata.speakers).empty?
      puts "No speakers for Video ID: #{video_id}"
      return
    end

    assign_attributes(
      event: event,
      title: static_metadata.title,
      description: static_metadata.description,
      date: static_metadata.try(:date) || static_metadata.published_at || Date.parse("#{static_metadata.year}-01-01"),
      thumbnail_xs: static_metadata.thumbnail_xs || "",
      thumbnail_sm: static_metadata.thumbnail_sm || "",
      thumbnail_md: static_metadata.thumbnail_md || "",
      thumbnail_lg: static_metadata.thumbnail_lg || "",
      thumbnail_xl: static_metadata.thumbnail_xl || "",
      language: static_metadata.language || Language::DEFAULT,
      slides_url: static_metadata.slides_url
    )

    self.speakers = Array.wrap(static_metadata.speakers).reject(&:blank?).map { |speaker_name|
      Speaker.find_by(slug: speaker_name.parameterize) || Speaker.find_or_create_by(name: speaker_name.strip)
    }

    self.slug = unused_slugs.first

    save!
  end

  def static_metadata
    Static::Video.find_by(video_id: video_id)
  end

  def suggestion_summary
    <<~HEREDOC
      Talk: #{title} (#{date})
      by #{speakers.map(&:name).to_sentence}
      at #{event.name}
    HEREDOC
  end
end
