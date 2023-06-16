# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: organisations
#
#  id                   :integer          not null, primary key
#  name                 :string           default(""), not null
#  description          :text             default(""), not null
#  website              :string           default(""), not null
#  kind                 :integer          default("conference"), not null
#  frequency            :integer          default("unknown"), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  youtube_channel_id   :string           default(""), not null
#  youtube_channel_name :string           default(""), not null
#  slug                 :string           default(""), not null
#
# rubocop:enable Layout/LineLength
class Organisation < ApplicationRecord
  include Sluggable
  include Suggestable
  slug_from :name

  # associations
  has_many :events, dependent: :destroy, inverse_of: :organisation, foreign_key: :organisation_id
  has_many :talks, through: :events

  # validations
  validates :name, presence: true

  # enums
  enum kind: {conference: 0, meetup: 1}
  enum frequency: {unknown: 0, yearly: 1, monthly: 2}

  def edition
    "#{name} 2022"
  end
end
