class TalksController < ApplicationController
  include Pagy::Backend
  skip_before_action :authenticate_user!
  before_action :set_talk, only: %i[show edit update]

  # GET /talks
  def index
    session[:talks_page] = params[:page] || 1
    if params[:q].present? || params[:years].present? || params[:event_ids].present?
      talks = Talk.includes(:speakers, :event).pagy_search(params[:q], filter: filtered_params, sort: ["year:desc"])
      @pagy, @talks = pagy_meilisearch(talks, items: 9, page: session[:talks_page]&.to_i || 1)
    else
      @pagy, @talks = pagy(Talk.all.order(date: :desc).includes(:speakers, :event), items: 9, page: session[:talks_page]&.to_i || 1)
    end
  end

  # GET /talks/1
  def show
    speaker_slug = params[:speaker_slug]
    @back_path = speaker_slug.present? ? speaker_path(speaker_slug, page: session[:talks_page]) : talks_path(page: session[:talks_page])
    set_meta_tags(@talk)
  end

  # GET /talks/1/edit
  def edit
  end

  # PATCH/PUT /talks/1
  def update
    suggestion = @talk.create_suggestion_from(params: talk_params, user: Current.user)
    if suggestion.persisted?
      redirect_to @talk, notice: suggestion.notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Generates filters for talks based on non-empty 'years' and 'event_ids' parameters.
  #
  # @return [Array<String>] Array of filters.
  def filtered_params
    years = params[:years].reject(&:empty?)
    event_ids = params[:event_ids].reject(&:empty?)

    filters = []
    filters += ["year IN #{years}"] unless years.empty?
    filters += ["event_id IN #{event_ids}"] unless event_ids.empty?
    filters
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.includes(:speakers, :event).find_by(slug: params[:slug])

    redirect_to talks_path, status: :moved_permanently if @talk.blank?
  end

  # Only allow a list of trusted parameters through.
  def talk_params
    params.require(:talk).permit(:title, :description, :slug, :year)
  end
end
