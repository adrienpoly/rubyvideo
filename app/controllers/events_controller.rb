class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_event, only: %i[show edit update]

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
  end

  # GET /events/1/edit
  def edit
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find_by(slug: params[:slug])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :website, :kind, :frequency)
  end
end
