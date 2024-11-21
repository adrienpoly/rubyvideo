class Talks::WatchedTalksController < ApplicationController
  include ActionView::RecordIdentifier
  include WatchedTalks

  before_action :set_talk
  after_action :broadcast_update_to_event_talks

  def create
    @talk.mark_as_watched!

    redirect_to @talk
  end

  def destroy
    @talk.unmark_as_watched!

    redirect_to @talk
  end

  private

  def set_talk
    @talk = Talk.find_by(slug: params[:talk_slug])
  end

  def broadcast_update_to_event_talks
    Turbo::StreamsChannel.broadcast_update_to [@talk.event, :talks],
                      target: dom_id(@talk.event, :talks),
                      partial: "events/talks/list",
                      method: :morph,
                      locals: {talks: @talk.event.talks,
                               active_talk: @talk,
                               watched_talks_ids: user_watched_talks_ids}
  end
end
