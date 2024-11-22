class TalksController < ApplicationController
  include Pagy::Backend
  include WatchedTalks
  skip_before_action :authenticate_user!
  before_action :set_talk, only: %i[show edit update]
  before_action :set_user_favorites, only: %i[index show]

  # GET /talks
  def index
    @talks = Talk.with_essential_card_data.order(order_by)
    @talks = @talks.ft_search(params[:s]).with_snippets.ranked if params[:s].present?
    @talks = @talks.for_topic(params[:topic]) if params[:topic].present?
    @talks = @talks.for_event(params[:event]) if params[:event].present?
    @talks = @talks.for_speaker(params[:speaker]) if params[:speaker].present?
    @talks = @talks.where(kind: talk_kind) if talk_kind.present?
    @pagy, @talks = pagy(@talks, items: 20, page: params[:page]&.to_i || 1)
  end

  # GET /talks/1
  def show
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

  def order_by
    @order_by ||= params[:order_by].presence_in(%w[date_desc date_asc]).then do |order|
      {
        "date_desc" => "talks.date DESC",
        "date_asc" => "talks.date ASC"
      }[order] || "talks.date DESC"
    end
  end

  def talk_kind
    @talk_kind ||= params[:kind].presence_in(Talk.kinds.keys)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.includes(:approved_topics, speakers: :user, event: :organisation).find_by(slug: params[:slug])
    return redirect_to talks_path, status: :moved_permanently if @talk.blank?

    @related_talks = @talk.event.talks.with_essential_card_data.order(date: :desc)
  end

  # Only allow a list of trusted parameters through.
  def talk_params
    params.require(:talk).permit(:title, :description, :summarized_using_ai, :summary, :date)
  end

  def set_user_favorites
    return unless Current.user

    @user_favorite_talks_ids = Current.user.default_watch_list.talks.ids
  end
end
