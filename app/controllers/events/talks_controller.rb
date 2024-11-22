class Events::TalksController < ApplicationController
  include WatchedTalks
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_event, only: %i[index]

  def index
    @talks = @event.talks
    @active_talk = Talk.find_by(slug: params[:active_talk])
  end

  private

  def set_event
    @event = Event.includes(:organisation, talks: :speakers).find_by(slug: params[:event_slug])
  end
end
