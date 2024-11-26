# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talks
#
#  id                  :integer          not null, primary key
#  date                :date             indexed
#  description         :text             default(""), not null
#  enhanced_transcript :text             default(#<Transcript:0x0000000120e51930 @cues=[]>), not null
#  external_player     :boolean          default(FALSE), not null
#  external_player_url :string           default(""), not null
#  kind                :string           default("talk"), not null, indexed
#  language            :string           default("en"), not null
#  like_count          :integer
#  raw_transcript      :text             default(#<Transcript:0x0000000120e51a98 @cues=[]>), not null
#  slides_url          :string
#  slug                :string           default(""), not null, indexed
#  summarized_using_ai :boolean          default(TRUE), not null
#  summary             :text             default(""), not null
#  thumbnail_lg        :string           default(""), not null
#  thumbnail_md        :string           default(""), not null
#  thumbnail_sm        :string           default(""), not null
#  thumbnail_xl        :string           default(""), not null
#  thumbnail_xs        :string           default(""), not null
#  title               :string           default(""), not null, indexed
#  video_provider      :string           default("youtube"), not null
#  view_count          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null, indexed
#  event_id            :integer          indexed
#  video_id            :string           default(""), not null
#
# Indexes
#
#  index_talks_on_date        (date)
#  index_talks_on_event_id    (event_id)
#  index_talks_on_kind        (kind)
#  index_talks_on_slug        (slug)
#  index_talks_on_title       (title)
#  index_talks_on_updated_at  (updated_at)
#
# Foreign Keys
#
#  event_id  (event_id => events.id)
#
# rubocop:enable Layout/LineLength
class Talk < ApplicationRecord
  extend ActiveJob::Performs
  include Talk::TranscriptCommands
  include Talk::SummaryCommands
  include Sluggable
  include Suggestable
  include Searchable
  include Watchable
  slug_from :title

  # include MeiliSearch::Rails
  # extend Pagy::Meilisearch

  # associations
  belongs_to :event, optional: true, counter_cache: :talks_count, touch: true
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

  # delegates
  delegate :name, to: :event, prefix: true, allow_nil: true

  # callbacks
  before_validation :set_kind, if: -> { !kind_changed? }

  # enums
  enum :video_provider, %w[youtube mp4 scheduled not_published not_recorded].index_by(&:itself)
  enum :kind,
    %w[talk keynote lightning_talk panel workshop gameshow podcast q_and_a discussion fireside_chat
      interview award].index_by(&:itself)

  # attributes
  attribute :video_provider, default: :youtube

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
  scope :for_topic, ->(topic_slug) { joins(:topics).where(topics: {slug: topic_slug}) }
  scope :for_speaker, ->(speaker_slug) { joins(:speakers).where(speakers: {slug: speaker_slug}) }
  scope :for_event, ->(event_slug) { joins(:event).where(events: {slug: event_slug}) }

  scope :with_essential_card_data, -> do
    select(:id, :slug, :title, :date, :thumbnail_sm, :thumbnail_lg, :video_id, :video_provider, :event_id, :language)
      .includes(:speakers, event: :organisation)
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
          _: thumbnail_xl,
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
          src: thumbnail_xl
        }
      }
    }
  end

  def thumbnail_xs
    thumbnail(:thumbnail_xs)
  end

  def thumbnail_sm
    thumbnail(:thumbnail_sm)
  end

  def thumbnail_md
    thumbnail(:thumbnail_md)
  end

  def thumbnail_lg
    thumbnail(:thumbnail_lg)
  end

  def thumbnail_xl
    thumbnail(:thumbnail_xl)
  end

  def fallback_thumbnail
    "/assets/#{Rails.application.assets.load_path.find("events/default/poster.webp").digested_path}"
  end

  def thumbnail(size = :thumbnail_lg)
    if self[size].present?
      return self[size] if self[size].start_with?("https://")

      if (asset = Rails.application.assets.load_path.find(self[size]))
        return "/assets/#{asset.digested_path}"
      elsif event && (asset = Rails.application.assets.load_path.find(event.poster_image_path))
        return "/assets/#{asset.digested_path}"
      else
        return fallback_thumbnail
      end
    end

    if !youtube? && event && (asset = Rails.application.assets.load_path.find(event.poster_image_path))
      return "/assets/#{asset.digested_path}"
    end

    return fallback_thumbnail unless youtube?

    youtube = {
      thumbnail_xs: "default",
      thumbnail_sm: "mqdefault",
      thumbnail_md: "hqdefault",
      thumbnail_lg: "sddefault",
      thumbnail_xl: "maxresdefault"
    }

    "https://i.ytimg.com/vi/#{video_id}/#{youtube[size]}.jpg"
  end

  def external_player_utm_params
    {
      utm_source: "rubyvideo.dev",
      utm_medium: "referral",
      utm_campaign: event.slug,
      utm_content: slug
    }
  end

  def external_player_url
    uri = URI.parse(self[:external_player_url].presence || provider_url)

    existing_params = URI.decode_www_form(uri.query || "").to_h
    updated_params = existing_params.merge(external_player_utm_params)

    uri.query = URI.encode_www_form(updated_params)

    uri.to_s
  end

  def provider_url
    case video_provider
    when "youtube"
      "https://www.youtube.com/watch?v=#{video_id}"
    else
      "#"
    end
  end

  def related_talks(limit: 6)
    ids = Rails.cache.fetch(["talk_recommendations", id, limit], expires_in: 1.week) do
      Talk.order("RANDOM()").excluding(self).limit(limit).ids
    end

    Talk.includes(event: :organisation).where(id: ids)
  end

  def formatted_date
    date.strftime("%B %d, %Y")
  rescue => _e
    # TODO: notify to error tracking

    "Unknown"
  end

  def transcript
    enhanced_transcript.presence || raw_transcript
  end

  def speaker_names
    speakers.pluck(:name).join(" ")
  end

  def slug_candidates
    @slug_candidates ||= [
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
    used_slugs = Talk.excluding(self).where(slug: slug_candidates).pluck(:slug)
    slug_candidates - used_slugs
  end

  def event_name
    return event.name unless event.organisation.meetup?

    static_metadata.try("event_name") || event.name
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

    date = static_metadata.try(:date) ||
      static_metadata.try(:published_at) ||
      event.start_date ||
      event.end_date ||
      Date.parse("#{static_metadata.year}-01-01")

    assign_attributes(
      event: event,
      title: static_metadata.title,
      description: static_metadata.description,
      date: date,
      thumbnail_xs: static_metadata["thumbnail_xs"] || "",
      thumbnail_sm: static_metadata["thumbnail_sm"] || "",
      thumbnail_md: static_metadata["thumbnail_md"] || "",
      thumbnail_lg: static_metadata["thumbnail_lg"] || "",
      thumbnail_xl: static_metadata["thumbnail_xl"] || "",
      language: static_metadata.language || Language::DEFAULT,
      slides_url: static_metadata.slides_url,
      video_provider: static_metadata.video_provider || :youtube,
      external_player: static_metadata.external_player || false,
      external_player_url: static_metadata.external_player_url || ""
    )

    self.kind = static_metadata.kind if static_metadata.try(:kind).present?

    self.speakers = Array.wrap(static_metadata.speakers).reject(&:blank?).map { |speaker_name|
      Speaker.find_by(slug: speaker_name.parameterize) || Speaker.find_or_create_by(name: speaker_name.strip)
    }

    self.slug = unused_slugs.first

    save!
  end

  def static_metadata
    @static_metadata ||= Static::Video.find_by(video_id: video_id)
  end

  def suggestion_summary
    <<~HEREDOC
      Talk: #{title} (#{date})
      by #{speakers.map(&:name).to_sentence}
      at #{event.name}
    HEREDOC
  end

  def set_kind
    if static_metadata && static_metadata.kind.present?
      unless static_metadata.kind.in?(Talk.kinds.keys)
        puts %(WARN: "#{title}" has an unknown talk kind defined in #{static_metadata.__file_path})
      end

      self.kind = static_metadata.kind
      return
    end

    self.kind = case title
    when /.*(keynote:|opening\ keynote|closing\ keynote|keynote|opening\ keynote|closing\ keynote).*/i
      :keynote
    when /.*(lightning\ talk:|lightning\ talk|lightning\ talks|micro\ talk:|micro\ talk).*/i
      :lightning_talk
    when /.*(panel:|panel).*/i
      :panel
    when /.*(workshop:|workshop).*/i
      :workshop
    when /.*(gameshow|game\ show|gameshow:|game\ show:).*/i
      :gameshow
    when /.*(podcast:|podcast\ recording:|live\ podcast:).*/i
      :podcast
    when /.*(q&a|q&a:|ama|q&a\ with|ruby\ committers\ vs\ the\ world|ruby\ committers\ and\ the\ world).*/i
      :q_and_a
    when /.*(fishbowl:|fishbowl\ discussion:|discussion:|discussion).*/i
      :discussion
    when /.*(fireside\ chat:|fireside\ chat).*/i
      :fireside_chat
    when /^(interview:|interview\ with).*/i
      :interview
    when /.*(award:|award\ show|ruby\ hero\ awards|ruby\ hero\ award|rails\ luminary).*/i
      :award
    else
      :talk
    end
  end
end
