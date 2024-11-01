class ContributionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    speaker_ids_with_pending_github_suggestions = Suggestion.pending.where("json_extract(content, '$.github') IS NOT NULL").where(suggestable_type: "Speaker").pluck(:suggestable_id)
    @speakers_without_github = Speaker.canonical.without_github.order(talks_count: :desc).where.not(id: speaker_ids_with_pending_github_suggestions)
    @speakers_without_github_count = @speakers_without_github.count

    speakers_with_speakerdeck = Speaker.where.not(speakerdeck: "")
    @talks_without_slides = Talk.preload(:speakers).joins(:speakers).where(slides_url: nil).where(speakers: {id: speakers_with_speakerdeck}).order(date: :desc)
    @talks_without_slides_count = @talks_without_slides.count

    @events_without_videos = Event.left_joins(:talks).where(talks_count: 0).group_by(&:organisation)
    @events_without_videos_count = @events_without_videos.flat_map(&:last).count

    @events_without_location = Static::Playlist.where(location: nil).group_by(&:__file_path)
    @events_without_location_count = @events_without_location.flat_map(&:last).count

    @events_without_dates = Static::Playlist.where(start_date: nil).group_by(&:__file_path)
    @events_without_dates_count = @events_without_dates.flat_map(&:last).count


    # Review Talk Dates

    @dates_by_event_name = (
      Static::Playlist.all.where.not(start_date: nil).pluck(:title, :start_date, :end_date).select { |_, start_date| start_date.present? }.map { |name, start_date, end_date| [name, Date.parse(start_date)..Date.parse(end_date)] }.union(
        Static::Playlist.all.where(start_date: nil).pluck(:title, :year).map { |title, year| [title, Date.parse("#{year}-01-01").all_year] }
      )
    ).to_h

    talks_by_event_name = Talk.preload(:event).to_a.select { |talk| talk.event.name.in?(@dates_by_event_name.keys) }.group_by(&:event)

    @out_of_bound_talks = talks_by_event_name.map { |event, talks| [event, talks.reject { |talk| @dates_by_event_name[event.name].cover?(talk.date) }] }
    @out_of_bound_talks_count = @out_of_bound_talks.map(&:last).flatten.count


    # Missing events

    conference_names = Event.all.pluck(:name)
    @upstream_conferences = RubyConferences::Client.new.conferences_cached.reverse
    @pending_conferences = @upstream_conferences.reject { |conference| conference["name"].in?(conference_names) }

    @with_video_link, @without_video_link = @pending_conferences.partition { |conference| conference["video_link"].present? }

    @conferences_to_index = @with_video_link.count + @without_video_link.count
    @already_index_conferences = @upstream_conferences.count - @conferences_to_index
  end
end
