# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  date            :date
#  city            :string
#  country_code    :string
#  organisation_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string           default(""), not null
#  slug            :string           default(""), not null
#
# rubocop:enable Layout/LineLength
class Event < ApplicationRecord
  include Suggestable
  include Sluggable
  slug_from :name

  # associations
  belongs_to :organisation
  has_many :talks, dependent: :destroy, inverse_of: :event, foreign_key: :event_id

  # validations
  validates :name, presence: true
  VALID_COUNTRY_CODES = ISO3166::Country.codes
  validates :country_code, inclusion: {in: VALID_COUNTRY_CODES}, allow_nil: true
end
