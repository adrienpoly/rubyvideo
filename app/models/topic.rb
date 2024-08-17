class Topic < ApplicationRecord
  include Sluggable

  slug_from :name

  has_many :talk_topics
  has_many :talks, through: :talk_topics
  belongs_to :canonical, class_name: "Topic", optional: true
  has_many :aliases, class_name: "Topic", foreign_key: "canonical_id"

  # validations
  validates :name, presence: true, uniqueness: true
  validates :canonical, exclusion: {in: ->(topic) { [topic] }, message: "can't be itself"}

  # normalize attributes
  normalizes :name, with: ->(name) { name.squish }

  # scopes
  scope :with_talks, -> { joins(:talks).distinct }
  scope :without_talks, -> { where.missing(:talk_topics) }
  scope :canonical, -> { where(canonical_id: nil) }
  scope :with_aliases, -> { where.not(canonical_id: nil) }

  # enums
  enum :status, %w[pending approved rejected duplicate].index_by(&:itself)

  def self.create_from_list(topics, status: :pending)
    topics.map { |topic|
      Topic.find_by(name: topic)&.primary_topic || Topic.find_or_create_by(name: topic, status: status)
    }.uniq
  end

  def assign_canonical_topic!(canonical_topic:)
    ActiveRecord::Base.transaction do
      self.canonical = canonical_topic
      save!

      talk_topics.each do |talk_topic|
        talk_topic.update(topic: canonical_topic)
      end

      # We need to destroy the remaining topics. They can be remaining topics given the unicity constraint
      # on the talk_topics table. the update above swallows the error if the talk_topic duet exists already
      TalkTopic.where(topic_id: id).destroy_all
      duplicate!
    end
  end

  def primary_topic
    canonical || self
  end
end
