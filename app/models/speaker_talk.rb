# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: speaker_talks
#
#  speaker_id :integer          not null
#  talk_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Layout/LineLength
class SpeakerTalk < ApplicationRecord
  self.table_name = "speaker_talks"

  # associations
  belongs_to :speaker, counter_cache: :talks_count
  belongs_to :talk

  validates :speaker_id, uniqueness: {scope: :talk_id}
end
