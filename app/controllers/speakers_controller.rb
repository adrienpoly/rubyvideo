class SpeakersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_speaker, only: %i[show edit update]
  before_action :set_user_favorites, only: %i[show]
  include Pagy::Backend
  include RemoteModal
  allowed_remote_modal_actions :edit

  # GET /speakers
  def index
    respond_to do |format|
      format.html do
        @speakers = Speaker.with_talks.order(:name).select(:id, :name, :slug, :talks_count, :github, :updated_at)
        @speakers = @speakers.where("lower(name) LIKE ?", "#{params[:letter].downcase}%") if params[:letter].present?
      end
      format.json do
        @pagy, @speakers = pagy(Speaker.includes(:canonical).order(:name), limit: params[:per_page])
      end
    end
  end

  # GET /speakers/1
  def show
    @talks = @speaker.talks.with_essential_card_data.order(date: :desc)
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

  helper_method :user_kind
  def user_kind
    return params[:user_kind] if params[:user_kind].present? && Rails.env.development?
    return :admin if Current.user&.admin?
    return :owner if @speaker.managed_by?(Current.user)
    return :signed_in if Current.user.present?

    :anonymous
  end

  def set_speaker
    @speaker = Speaker.includes(:talks).find_by!(slug: params[:slug])
    redirect_to speaker_path(@speaker.canonical) if @speaker.canonical.present?
  end

  def speaker_params
    params.require(:speaker).permit(:name, :twitter, :github, :bio, :website, :speakerdeck, :pronouns_type, :pronouns)
  end

  def set_user_favorites
    return unless Current.user

    @user_favorite_talks_ids = Current.user.default_watch_list.talks.ids
  end
end
