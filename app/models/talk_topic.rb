class TalkTopic < ApplicationRecord
  belongs_to :talk
  belongs_to :topic

  validates :talk_id, uniqueness: {scope: :topic_id}
end
