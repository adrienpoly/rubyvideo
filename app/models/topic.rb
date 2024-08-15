class Topic < ApplicationRecord
  has_many :talk_topics
  has_many :talks, through: :talk_topics

  # validations
  validates :name, presence: true, uniqueness: true

  # normalize attributes
  normalizes :name, with: ->(name) { name.squish }
end
