# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: speakers
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  twitter     :string           default(""), not null
#  github      :string           default(""), not null
#  bio         :text             default(""), not null
#  website     :string           default(""), not null
#  slug        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  talks_count :integer          default(0), not null
#
# rubocop:enable Layout/LineLength
class Speaker < ApplicationRecord
  include ActionView::RecordIdentifier
  include Sluggable
  include Suggestable
  slug_from :name

  # associations
  has_many :speaker_talks, dependent: :destroy, inverse_of: :speaker, foreign_key: :speaker_id
  has_many :talks, through: :speaker_talks

  # scope
  scope :with_talks, -> { where.not(talks_count: 0) }
  scope :with_github, -> { where.not(github: "") }
  scope :without_github, -> { where(github: "") }

  def github_avatar_url(size: 200)
    "https://github.com/#{github}.png?size=#{size}"
  end

  def broadcast_about
    broadcast_update_to self, target: dom_id(self, :about), partial: "speakers/about", locals: {speaker: self}
  end
end
