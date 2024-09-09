# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: playlists
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  name        :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# rubocop:enable Layout/LineLength
class WatchList < ApplicationRecord
  belongs_to :user
  has_many :watch_list_talks, dependent: :destroy
  has_many :talks, through: :watch_list_talks

  validates :name, presence: true
end
