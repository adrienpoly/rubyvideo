class Talks::WatchedTalksController < ApplicationController
  before_action :set_talk

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
end
