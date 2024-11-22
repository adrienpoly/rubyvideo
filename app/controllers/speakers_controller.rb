class SpeakersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_speaker, only: %i[show edit update]
  before_action :set_user_favorites, only: %i[show]
  include Pagy::Backend
  include RemoteModal
  include WatchedTalks
  respond_with_remote_modal only: [:edit]

  # GET /speakers
  def index
    @speakers = Speaker.with_talks.order(:name).canonical
    @speakers = @speakers.where("lower(name) LIKE ?", "#{params[:letter].downcase}%") if params[:letter].present?
    @speakers = @speakers.ft_search(params[:s]) if params[:s].present?
    @pagy, @speakers = pagy(@speakers, limit: 100, page: params[:page])
    respond_to do |format|
      format.html
      format.turbo_stream
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
    params.require(:speaker).permit(
      :name,
      :github,
      :twitter,
      :bsky,
      :linkedin,
      :mastodon,
      :bio,
      :website,
      :speakerdeck,
      :pronouns_type,
      :pronouns,
      :slug
    )
  end

  def set_user_favorites
    return unless Current.user

    @user_favorite_talks_ids = Current.user.default_watch_list.talks.ids
  end
end
