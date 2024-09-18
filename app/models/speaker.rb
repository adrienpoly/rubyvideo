# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: speakers
#
#  id           :integer          not null, primary key
#  name         :string           default(""), not null
#  twitter      :string           default(""), not null
#  github       :string           default(""), not null
#  bio          :text             default(""), not null
#  website      :string           default(""), not null
#  slug         :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  talks_count  :integer          default(0), not null
#  canonical_id :integer
#
# rubocop:enable Layout/LineLength
class Speaker < ApplicationRecord
  include ActionView::RecordIdentifier
  include Sluggable
  include Suggestable
  slug_from :name

  # associations
  has_many :speaker_talks, dependent: :destroy, inverse_of: :speaker, foreign_key: :speaker_id
  has_many :talks, through: :speaker_talks, inverse_of: :speakers
  has_many :aliases, class_name: "Speaker", foreign_key: "canonical_id"

  belongs_to :canonical, class_name: "Speaker", optional: true
  belongs_to :user, primary_key: :github_handle, foreign_key: :github, optional: true

  # validations
  validates :canonical, exclusion: {in: ->(speaker) { [speaker] }, message: "can't be itself"}

  # scope
  scope :with_talks, -> { where.not(talks_count: 0) }
  scope :with_github, -> { where.not(github: "") }
  scope :without_github, -> { where(github: "") }
  scope :canonical, -> { where(canonical_id: nil) }
  scope :not_canonical, -> { where.not(canonical_id: nil) }

  # normalizes
  normalizes :twitter, with: ->(value) { value.gsub(%r{https?://(?:www\.)?(?:x\.com|twitter\.com)/}, "").gsub(/@/, "") }

  def title
    name
  end

  def managed_by?(visiting_user)
    return false unless visiting_user.present?
    return true if visiting_user.admin?

    user == visiting_user
  end

  def github_avatar_url(size: 200)
    return "" unless github.present?

    "https://github.com/#{github}.png?size=#{size}"
  end

  def broadcast_about
    broadcast_update_to self, target: dom_id(self, :about), partial: "speakers/about", locals: {speaker: self}
  end

  def valid_website_url
    return "#" if website.blank?

    # if it already starts with https://, return as is
    return website if website.start_with?("https://")

    # if it starts with http://, convert it to https://
    return website.sub("http://", "https://") if website.start_with?("http://")

    # otherwise, prepend https://
    "https://#{website}"
  end

  def to_meta_tags
    {
      title: meta_title,
      description: meta_description,
      og: {
        title: meta_title,
        type: :website,
        image: {
          _: github_avatar_url,
          alt: meta_title
        },
        description: meta_description,
        site_name: "RubyVideo.dev"
      },
      twitter: {
        card: "summary_large_image",
        site: twitter,
        title: meta_title,
        description: meta_description,
        image: {
          src: github_avatar_url
        }
      }
    }
  end

  def meta_title
    "Conferences talks from #{name}"
  end

  def meta_description
    <<~HEREDOC
      Discover all the talks given by #{name} on subjects related to Ruby language or Ruby Frameworks such as Rails, Hanami and others
    HEREDOC
  end

  def assign_canonical_speaker!(canonical_speaker:)
    ActiveRecord::Base.transaction do
      self.canonical = canonical_speaker
      save!

      speaker_talks.each do |speaker_talk|
        speaker_talk.update(speaker: canonical_speaker)
      end

      # We need to destroy the remaining speaker_talks. They can be remaining given the unicity constraint
      # on the speaker_talks table. The update above swallows the error if the speaker_talk duet exists already
      SpeakerTalk.where(speaker_id: id).destroy_all
      Speaker.reset_counters(canonical_speaker.id, :talks)
    end
  end

  def primary_speaker
    canonical || self
  end

  # Add this method for rejecting a speaker
  def rejected!
    ActiveRecord::Base.transaction do
      update!(status: :rejected)
      SpeakerTalk.where(speaker_id: id).destroy_all
    end
  end

  def suggestion_summary
    <<~HEREDOC
      Speaker: #{name}
      github: #{github}
      twitter: #{twitter}
      website: #{website}
      bio: #{bio}
    HEREDOC
  end
end
