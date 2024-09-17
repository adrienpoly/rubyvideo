class TalksController < ApplicationController
  include Pagy::Backend
  skip_before_action :authenticate_user!
  before_action :set_talk, only: %i[show edit update]
  before_action :set_user_favorites, only: %i[index show]

  # GET /talks
  def index
    if params[:q].present?
      talks = Talk.includes(:speakers, :event).pagy_search(params[:q])
      @pagy, @talks = pagy_meilisearch(talks, limit: 21, page: params[:page]&.to_i || 1)
    else
      @pagy, @talks = pagy(Talk.all.order(date: :desc).includes(:speakers, :event), limit: 21, page: params[:page]&.to_i || 1)
    end
  end

  # GET /talks/1
  def show
    set_meta_tags(@talk)
    fresh_when(@talk)
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

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.includes(:speakers, :event, :approved_topics).find_by(slug: params[:slug])

    redirect_to talks_path, status: :moved_permanently if @talk.blank?
  end

  # Only allow a list of trusted parameters through.
  def talk_params
    params.require(:talk).permit(:title, :description, :summary, :date)
  end

  def set_user_favorites
    return unless Current.user

    @user_favorite_talks_ids = Current.user.default_watch_list.talks.ids
  end
end
