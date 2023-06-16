class PageController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    home_page_cached_data = Rails.cache.fetch("home_page", expires_in: 1.minute) do
      speakers = Speaker.with_github.order("RANDOM()").limit(5)

      {
        speakers_avatar_url: speakers.map { |speaker| [speaker.github_avatar_url(size: 250), speaker.github_avatar_url(size: 500)] },
        speakers_github: speakers.map(&:github),
        talks_count: Talk.count,
        speakers_count: Speaker.count
      }
    end

    @speakers_avatar_url = home_page_cached_data[:speakers_avatar_url]
    @speakers_github = home_page_cached_data[:speakers_github]
    @talks_count = home_page_cached_data[:talks_count]
    @speakers_count = home_page_cached_data[:speakers_count]
  end
end
