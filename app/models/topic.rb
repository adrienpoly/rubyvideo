class Topic < ApplicationRecord
  has_many :talk_topics
  has_many :talks, through: :talk_topics
end
