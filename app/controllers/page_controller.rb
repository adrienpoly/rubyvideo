class PageController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    home_page_cached_data = Rails.cache.fetch("home_page_content", expires_in: 1.hour) do
      latest_talks = Talk.order(date: :desc).limit(10)
      {
        talks_count: Talk.count,
        speakers_count: Speaker.count,
        latest_talk_ids: latest_talks.pluck(:id).sample(4),
        latest_event_ids: Event.order(date: :desc).limit(10).pluck(:id).sample(4),
        featured_speaker_ids: Speaker.with_github
          .joins(:talks)
          .where(talks: {date: 12.months.ago..})
          .pluck(:id)
      }
    end

    @talks_count = home_page_cached_data[:talks_count]
    @speakers_count = home_page_cached_data[:speakers_count]
    @latest_talks = Talk.includes(event: :organisation).where(id: home_page_cached_data[:latest_talk_ids])
    @latest_events = Event.includes(:organisation).where(id: home_page_cached_data[:latest_event_ids])
    @featured_speakers = Speaker.where(id: home_page_cached_data[:featured_speaker_ids])

    # Add featured events logic
    playlist_slugs = Static::Playlist.where.not(featured_background: nil)
      .select(&:today_or_past?)
      .sort_by(&:home_sort_date)
      .reverse
      .take(15)
      .map(&:slug)

    @featured_events = Event.distinct
      .includes(:organisation)
      .where(slug: playlist_slugs)
      .where.associated(:talks)
      .in_order_of(:slug, playlist_slugs)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          featured: featured_events_for_featured,
          talks: [
            {
              name: "Latest Talks",
              items: @latest_talks,
              url: ""
            },
            {
              name: "Trending Talks",
              items: @latest_talks,
              url: ""
            }
          ],
          speakers: [
            {
              name: "Featured Speakers",
              items: @featured_speakers,
              url: ""
            }
          ],
          events: [
            {
              name: "Featured Events",
              items: @featured_events,
              url: ""
            }
          ]
        }
      }
    end
  end

  def featured
  end

  def components
  end

  def uses
  end

  private

  def featured_events_for_featured
    @featured_events.map do |event|
      {
        id: event.slug,
        name: event.name,
        location: event.location,
        start_date: event.start_date&.to_s,
        end_date: event.end_date&.to_s,
        featured_background: event.featured_background,
        featured_color: event.featured_color,
        url: root_url(path: "/events/#{event.slug}")
      }
    end
  end
end
