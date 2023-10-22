class SpeakersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_speaker, only: %i[show edit update]

  # GET /speakers
  def index
    @speakers = Speaker.all.order(:name).select(:id, :name, :slug, :talks_count)
  end

  # GET /speakers/1
  def show
    @talks = @speaker.talks
    @back_path = speakers_path
    set_meta_tags(@speaker)
    # fresh_when(@speaker)
  end

  # GET /speakers/1/edit
  def edit
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
