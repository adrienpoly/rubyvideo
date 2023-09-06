class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show update]
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
    suggestion = @event.create_suggestion_from(params: event_params, user: Current.user)

    if suggestion.persisted?
      redirect_to event_path(@event), notice: suggestion.notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find_by!(slug: params[:slug])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :city, :country_code)
  end
end
