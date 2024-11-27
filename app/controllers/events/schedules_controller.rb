class Events::SchedulesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_event, only: %i[show]

  def show
  end

  private

  def set_event
    @event = Event.includes(organisation: :events).find_by!(slug: params[:event_slug])

    redirect_to schedule_event_path(@event.canonical), status: :moved_permanently if @event.canonical.present?
    redirect_to event_path(@event), notice: "Event doesn't have a schedule" unless @event.schedule_file?
  end
end
