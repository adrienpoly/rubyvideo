class Topic < ApplicationRecord
  include Sluggable

  slug_from :name

  has_many :talk_topics
  has_many :talks, through: :talk_topics

  # validations
  validates :name, presence: true, uniqueness: true

  # normalize attributes
  normalizes :name, with: ->(name) { name.squish }

  scope :published, -> { where(published: true) }
  scope :with_talks, -> { joins(:talks).distinct }
end
