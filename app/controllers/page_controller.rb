class PageController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    home_page_cached_data = Rails.cache.fetch("home_page_content", expires_in: 1.hour) do
      {
        talks_count: Talk.count,
        speakers_count: Speaker.count,
        latest_talk_ids: Talk.order(date: :desc).limit(50).pluck(:id).sample(4),
        latest_event_ids: Event.order(date: :desc).limit(10).pluck(:id).sample(4),
        active_speaker_ids: Speaker.with_github.order(talks_count: :desc).limit(30).pluck(:id).sample(4)
      }
    end

    @talks_count = home_page_cached_data[:talks_count]
    @speakers_count = home_page_cached_data[:speakers_count]
    @latest_talks = Talk.includes(event: :organisation).where(id: home_page_cached_data[:latest_talk_ids])
    @latest_events = Event.includes(:organisation).where(id: home_page_cached_data[:latest_event_ids])
    @active_speakers = Speaker.where(id: home_page_cached_data[:active_speaker_ids])
  end

  def featured
  end
end
