# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talk_topics
#
#  id         :integer          not null, primary key
#  talk_id    :integer          not null
#  topic_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Layout/LineLength
class TalkTopic < ApplicationRecord
  belongs_to :talk
  belongs_to :topic

  validates :talk_id, uniqueness: {scope: :topic_id}
end
