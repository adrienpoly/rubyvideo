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
    @talk = Talk.includes(event: :organisation).find_by(slug: params[:talk_slug])
  end

  def broadcast_update_to_event_talks
    Turbo::StreamsChannel.broadcast_replace_to [@talk.event, :talks],
      target: dom_id(@talk, :card_horizontal),
      partial: "talks/card_horizontal",
      method: :replace,
      locals: {compact: true,
               talk: @talk,
               current_talk: @talk,
               turbo_frame: "talk",
               watched_talks_ids: user_watched_talks_ids}
  end
end
