# == Schema Information
#
# Table name: watched_talks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  talk_id    :integer          not null, indexed, indexed => [user_id]
#  user_id    :integer          not null, indexed => [talk_id], indexed
#
# Indexes
#
#  index_watched_talks_on_talk_id              (talk_id)
#  index_watched_talks_on_talk_id_and_user_id  (talk_id,user_id) UNIQUE
#  index_watched_talks_on_user_id              (user_id)
#
class WatchedTalk < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :talk
end
