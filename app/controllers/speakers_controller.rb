class SpeakersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_speaker, only: %i[show edit update destroy]

  # GET /speakers
  def index
    @speakers = Speaker.all.order(:name).select(:id, :name, :slug, :talks_count)
  end

  # GET /speakers/1
  def show
    @from_talk_id = session[:from_talk_id]
    session[:from_talk_id] = nil
    @talks = @speaker.talks
    @back_path = speakers_path
    # fresh_when(@speaker)
  end

  # GET /speakers/new
  def new
    @speaker = Speaker.new
  end

  # GET /speakers/1/edit
  def edit
  end

  # POST /speakers
  def create
    @speaker = Speaker.new(speaker_params)

    if @speaker.save
      redirect_to @speaker, notice: "Speaker was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /speakers/1
  def update
    suggestion = @speaker.create_suggestion_from(params: speaker_params, user: Current.user)
    if suggestion.persisted?
      redirect_to @speaker, notice: suggestion.notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /speakers/1
  def destroy
    @speaker.destroy!
    redirect_to speakers_url, notice: "Speaker was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_speaker
    @speaker = Speaker.includes(:talks).find_by!(slug: params[:slug])
  end

  # Only allow a list of trusted parameters through.
  def speaker_params
    params.require(:speaker).permit(:name, :twitter, :github, :bio, :website, :slug)
  end
end
