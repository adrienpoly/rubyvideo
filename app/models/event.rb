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
end
