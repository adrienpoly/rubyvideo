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
#  twitter              :string           default(""), not null
#  language             :string           default(""), not null
#
# rubocop:enable Layout/LineLength
class Organisation < ApplicationRecord
  include Sluggable
  include Suggestable

  include ActionView::Helpers::TextHelper

  slug_from :name

  # associations
  has_many :events, dependent: :destroy, inverse_of: :organisation, foreign_key: :organisation_id
  has_many :talks, through: :events

  # validations
  validates :name, presence: true

  # enums
  enum :kind, {conference: 0, meetup: 1}
  enum :frequency, {unknown: 0, yearly: 1, monthly: 2, biyearly: 3}

  def title
    %(All #{name} #{kind.pluralize})
  end

  def description
    start_year = events.minimum(:date).year
    end_year = events.maximum(:date).year

    if start_year == end_year
      time_range = %(in #{start_year})
    else
      time_range = %(between #{start_year} and #{end_year})
    end

    <<~DESCRIPTION
      #{name} is a #{frequency} #{kind} and hosted #{pluralize(events.count, "event")} #{time_range}. We have currently indexed #{pluralize(events.sum { |event| event.talks_count }, "#{name} talk")}.
    DESCRIPTION
  end

  def to_meta_tags
    event = events.order(date: :desc).first

    {
      title: title,
      description: description,
      og: {
        title: title,
        type: :website,
        image: {
          _: event ? Router.image_path(event.card_image_path) : nil,
          alt: title
        },
        description: description,
        site_name: "RubyVideo.dev"
      },
      twitter: {
        card: "summary_large_image",
        site: "adrienpoly",
        title: title,
        description: description,
        image: {
          src: event ? Router.image_path(event.card_image_path) : nil
        }
      }
    }
  end
end
