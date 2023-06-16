class TalksController < ApplicationController
  include Pagy::Backend
  skip_before_action :authenticate_user!
  before_action :set_talk, only: %i[show edit update destroy]

  # GET /talks
  def index
    @from_talk_id = session[:from_talk_id]
    session[:from_talk_id] = nil
    @pagy, @talks = pagy(Talk.all.order(date: :desc).includes(:speakers, :event), items: 9)
  end

  # GET /talks/1
  def show
    speaker_slug = params[:speaker_slug]
    session[:from_talk_id] = @talk.id
    @back_path = speaker_slug.present? ? speaker_path(speaker_slug) : talks_path
    @talks = Talk.order("RANDOM()").excluding(@talk).limit(6)
    set_meta_tags(@talk)
  end

  # GET /talks/1/edit
  def edit
  end

  # POST /talks
  def create
    @talk = Talk.new(talk_params)

    if @talk.save
      redirect_to @talk, notice: "Talk was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
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

  # DELETE /talks/1
  def destroy
    @talk.destroy!
    redirect_to talks_url, notice: "Talk was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.includes(:speakers, :event).find_by(slug: params[:slug])
  end

  # Only allow a list of trusted parameters through.
  def talk_params
    params.require(:talk).permit(:title, :description, :slug, :year)
  end
end
