class TalkTopic < ApplicationRecord
  belongs_to :talk
  belongs_to :topic
end
