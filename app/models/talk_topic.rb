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
  belongs_to :topic, counter_cache: :talks_count

  validates :talk_id, uniqueness: {scope: :topic_id}

  def reset_topic_counter_cache
    Topic.reset_counters(topic_id, :talks)
  end
end
