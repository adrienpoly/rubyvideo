# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: speaker_talks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  speaker_id :integer          not null, indexed, indexed => [talk_id]
#  talk_id    :integer          not null, indexed => [speaker_id], indexed
#
# Indexes
#
#  index_speaker_talks_on_speaker_id              (speaker_id)
#  index_speaker_talks_on_speaker_id_and_talk_id  (speaker_id,talk_id) UNIQUE
#  index_speaker_talks_on_talk_id                 (talk_id)
#
# rubocop:enable Layout/LineLength
class SpeakerTalk < ApplicationRecord
  self.table_name = "speaker_talks"

  # associations
  belongs_to :speaker, counter_cache: :talks_count
  belongs_to :talk, touch: true

  validates :speaker_id, uniqueness: {scope: :talk_id}
end
