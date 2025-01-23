# == Schema Information
#
# Table name: social_profiles
#
#  id            :integer          not null, primary key
#  provider      :integer
#  sociable_type :string           indexed => [sociable_id]
#  value         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sociable_id   :integer          indexed => [sociable_type]
#
# Indexes
#
#  index_social_profiles_on_sociable  (sociable_type,sociable_id)
#
class SocialProfile < ApplicationRecord
  belongs_to :sociable, polymorphic: true

  enum :provider, {
    github: 0,
    twitter: 1,
    linkedin: 2,
    bsky: 3,
    mastadon: 4
  },
    suffix: true,
    validate: {presence: true}

  before_save do
    self.value = self.class.normalize_value_for(provider.to_sym, value)
  end

  # normalizes
  normalizes :github, with: ->(value) { value.gsub(/^(?:https?:\/\/)?(?:www\.)?github\.com\//, "").gsub(/^@/, "") }
  normalizes :twitter, with: ->(value) { value.gsub(%r{https?://(?:www\.)?(?:x\.com|twitter\.com)/}, "").gsub(/@/, "") }
  normalizes :linkedin, with: ->(value) { value.gsub(%r{https?://(?:www\.)?(?:linkedin\.com/in)/}, "") }
  normalizes :bsky, with: ->(value) { value.gsub(%r{https?://(?:www\.)?(?:[^\/]+\.com)/}, "").gsub(/@/, "") }
  normalizes :mastodon, with: ->(value) {
    return value if value&.match?(URI::DEFAULT_PARSER.make_regexp)
    return "" unless value.count("@") == 2

    _, handle, instance = value.split("@")

    "https://#{instance}/@#{handle}"
  }
end
