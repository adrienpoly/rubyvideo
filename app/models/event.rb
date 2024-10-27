# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  date            :date
#  city            :string
#  country_code    :string
#  organisation_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string           default(""), not null
#  slug            :string           default(""), not null
#  talks_count     :integer          default(0), not null
#  canonical_id    :integer
#
# rubocop:enable Layout/LineLength
class Event < ApplicationRecord
  include Suggestable
  include Sluggable
  slug_from :name

  # associations
  belongs_to :organisation
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
    talks.select { |talk|
      talk.title.start_with?("Keynote: ") ||
        talk.title.include?("Opening Keynote") ||
        talk.title.include?("Closing Keynote")
    }.flat_map(&:speakers)
  end

  def formatted_dates
    return start_date.strftime("%B %d, %Y") if start_date == end_date

    if start_date.strftime("%Y-%m") == end_date.strftime("%Y-%m")
      return "#{start_date.strftime("%B %d")}-#{end_date.strftime("%d")}, #{year}"
    end

    "#{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d, %Y")}"
  rescue => _e
    # TODO: notify to error tracking

    "Unknown"
  end

  def title
    %(All #{name} #{organisation.kind} talks)
  end

  def description
    held_in = country_code ? %( held in #{ISO3166::Country.new(country_code)&.iso_short_name}) : ""
    keynotes = keynote_speakers.any? ? %(, including keynotes by #{keynote_speakers.map(&:name).to_sentence}) : ""

    <<~DESCRIPTION
      #{organisation.name} is a #{organisation.frequency} #{organisation.kind}#{held_in} and features #{talks.count} #{"talk".pluralize(talks.count)} from various speakers#{keynotes}.
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

  def banner_background
    static_metadata.banner_background.present? ? static_metadata.banner_background : "#FF607F"
  rescue => _e
    "#FF607F"
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
    static_metadata.start_date.present? ? static_metadata.start_date.to_date : talks.minimum(:date)
  rescue => _e
    talks.minimum(:date)
  end

  def end_date
    static_metadata.end_date.present? ? static_metadata.end_date.to_date : talks.maximum(:date)
  rescue => _e
    talks.maximum(:date)
  end

  def year
    static_metadata.year.present? ? static_metadata.year : talks.first.date.year
  rescue => _e
    talks.first.date.year
  end
end
