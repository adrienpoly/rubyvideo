class TopicsController < ApplicationController
  include Pagy::Backend
  include WatchedTalks
  skip_before_action :authenticate_user!
  before_action :set_user_favorites, only: %i[show]

  def index
    @topics = Topic.approved.with_talks.order(name: :asc)
    @topics = @topics.where("lower(name) LIKE ?", "#{params[:letter].downcase}%") if params[:letter].present?
    @pagy, @topics = pagy(@topics, limit: 100, page: params[:page])
  end

  def show
    @topic = Topic.find_by!(slug: params[:slug])
  end

  def set_user_favorites
    return unless Current.user

    @user_favorite_talks_ids = Current.user.default_watch_list.talks.ids
  end
end
