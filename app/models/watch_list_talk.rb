# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: watch_list_talks
#
#  id            :integer          not null, primary key
#  watch_list_id :integer          not null
#  talk_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# rubocop:enable Layout/LineLength
class WatchListTalk < ApplicationRecord
  belongs_to :watch_list, counter_cache: :talks_count
  belongs_to :talk

  validates :watch_list_id, uniqueness: {scope: :talk_id}

  def reset_watch_list_counter_cache
    WatchList.reset_counters(watch_list_id, :talks)
  end
end
