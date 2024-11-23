# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  city            :string
#  country_code    :string
#  date            :date
#  name            :string           default(""), not null, indexed
#  slug            :string           default(""), not null, indexed
#  talks_count     :integer          default(0), not null
#  website         :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  canonical_id    :integer          indexed
#  organisation_id :integer          not null, indexed
#
# Indexes
#
#  index_events_on_canonical_id     (canonical_id)
#  index_events_on_name             (name)
#  index_events_on_organisation_id  (organisation_id)
#  index_events_on_slug             (slug)
#
# Foreign Keys
#
#  canonical_id     (canonical_id => events.id)
#  organisation_id  (organisation_id => organisations.id)
#
# rubocop:enable Layout/LineLength
class Event < ApplicationRecord
  include Suggestable
  include Sluggable
  slug_from :name

  # associations
  belongs_to :organisation, strict_loading: true
  has_many :talks, dependent: :destroy, inverse_of: :event, foreign_key: :event_id
  has_many :speakers, -> { distinct }, through: :talks
  has_many :topics, -> { distinct }, through: :talks
  belongs_to :canonical, class_name: "Event", optional: true
  has_many :aliases, class_name: "Event", foreign_key: "canonical_id"

  # validations
  validates :name, presence: true
  VALID_COUNTRY_CODES = ISO3166::Country.codes
  validates :country_code, inclusion: {in: VALID_COUNTRY_CODES}, allow_nil: true
  validates :canonical, exclusion: {in: ->(event) { [event] }, message: "can't be itself"}

  # scopes
  scope :without_talks, -> { where.missing(:talks) }
  scope :canonical, -> { where(canonical_id: nil) }
  scope :not_canonical, -> { where.not(canonical_id: nil) }
  scope :ft_search, ->(query) { where("lower(events.name) LIKE ?", "%#{query.downcase}%") }

  def assign_canonical_event!(canonical_event:)
    ActiveRecord::Base.transaction do
      self.canonical = canonical_event
      save!

      talks.update_all(event_id: canonical_event.id)
      Event.reset_counters(canonical_event.id, :talks)
    end
  end

  def managed_by?(user)
    Current.user&.admin?
  end

  def suggestion_summary
    <<~HEREDOC
      Event: #{name}
      #{description}
      #{city}
      #{country_code}
      #{organisation.name}
      #{date}
    HEREDOC
  end

  def keynote_speakers
    speakers.merge(talks.keynote)
  end

  def formatted_dates
    return start_date.strftime("%B %d, %Y") if start_date == end_date

    if start_date.strftime("%Y-%m") == end_date.strftime("%Y-%m")
      return "#{start_date.strftime("%B %d")}-#{end_date.strftime("%d")}, #{year}"
    end

    if start_date.strftime("%Y") == end_date.strftime("%Y")
      return "#{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d, %Y")}"
    end

    "#{start_date.strftime("%b %d, %Y")} - #{end_date.strftime("%b %d, %Y")}"
  rescue => _e
    # TODO: notify to error tracking

    "Unknown"
  end

  def title
    %(All #{name} #{organisation.kind} talks)
  end

  def country_name
    return nil if country_code.blank?

    ISO3166::Country.new(country_code)&.iso_short_name
  end

  def held_in_sentence
    return "" if country_name.blank?

    if country_name.starts_with?("United")
      %( held in the #{country_name})
    else
      %( held in #{country_name})
    end
  end

  def description
    keynotes = keynote_speakers.any? ? %(, including keynotes by #{keynote_speakers.map(&:name).to_sentence}) : ""

    <<~DESCRIPTION
      #{organisation.name} is a #{organisation.frequency} #{organisation.kind}#{held_in_sentence} and features #{talks.count} #{"talk".pluralize(talks.count)} from various speakers#{keynotes}.
    DESCRIPTION
  end

  def to_meta_tags
    {
      title: title,
      description: description,
      og: {
        title: title,
        type: :website,
        image: {
          _: Router.image_path(card_image_path),
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
          src: Router.image_path(card_image_path)
        }
      }
    }
  end

  def static_metadata
    Static::Playlist.find_by(slug: slug)
  end

  def event_image_path
    ["events", organisation.slug, slug].join("/")
  end

  def default_event_image_path
    ["events", "default"].join("/")
  end

  def event_image_or_default_for(filename)
    event_path = [event_image_path, filename].join("/")
    default_path = [default_event_image_path, filename].join("/")

    Rails.root.join("app", "assets", "images", event_image_path, filename).exist? ? event_path : default_path
  end

  def banner_image_path
    event_image_or_default_for("banner.webp")
  end

  def card_image_path
    event_image_or_default_for("card.webp")
  end

  def avatar_image_path
    event_image_or_default_for("avatar.webp")
  end

  def featured_image_path
    event_image_or_default_for("featured.webp")
  end

  def poster_image_path
    event_image_or_default_for("poster.webp")
  end

  def banner_background
    static_metadata.banner_background.present? ? static_metadata.banner_background : "#DC153C"
  rescue => _e
    "#DC153C"
  end

  def featurable?
    static_metadata && (static_metadata.featured_background.present? || static_metadata.featured_color.present?)
  end

  def featured_background
    return static_metadata.featured_background if static_metadata.featured_background.present?

    "black"
  rescue => _e
    "black"
  end

  def featured_color
    static_metadata.featured_color.present? ? static_metadata.featured_color : "white"
  rescue => _e
    "white"
  end

  def location
    static_metadata.location.present? ? static_metadata.location : "Earth"
  rescue => _e
    "Earth"
  end

  def start_date
    static_metadata.start_date.present? ? static_metadata.start_date : talks.minimum(:date)
  rescue => _e
    talks.minimum(:date)
  end

  def end_date
    static_metadata.end_date.present? ? static_metadata.end_date : talks.maximum(:date)
  rescue => _e
    talks.maximum(:date)
  end

  def year
    static_metadata.year.present? ? static_metadata.year : talks.first.date.year
  rescue => _e
    talks.first.date.year
  end

  def website
    self[:website].presence || organisation.website
  end
end
