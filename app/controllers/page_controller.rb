class PageController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    home_page_cached_data = Rails.cache.fetch("home_page", expires_in: 1.hour) do
      {
        talks_count: Talk.count,
        speakers_count: Speaker.count
      }
    end

    @talks_count = home_page_cached_data[:talks_count]
    @speakers_count = home_page_cached_data[:speakers_count]
    @latest_talks = Talk.order(date: :desc).limit(4)
    @latest_events = Event.order(date: :desc).limit(4)
    @active_speakers = Speaker.with_github.order(talks_count: :desc).limit(20).sample(4)
  end
end
