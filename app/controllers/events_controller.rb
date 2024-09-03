class EventsController < ApplicationController
  include Pagy::Backend
  skip_before_action :authenticate_user!, only: %i[index show update]
  before_action :set_event, only: %i[show edit update]

  # GET /events
  def index
    @events = Event.canonical.includes(:organisation).order(:name)
    @events = @events.where("lower(name) LIKE ?", "#{params[:letter].downcase}%") if params[:letter].present?
  end

  # GET /events/1
  def show
    event_talks = @event.talks
    if params[:q].present?
      talks = event_talks.pagy_search(params[:q])
      @pagy, @talks = pagy_meilisearch(talks, items: 9)
    else
      @pagy, @talks = pagy(event_talks.order(date: :desc).includes(:speakers), items: 9)
    end
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
    redirect_to event_path(@event.canonical), status: :moved_permanently if @event.canonical.present?
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :city, :country_code)
  end
end
