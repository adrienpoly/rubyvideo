class TopicsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @topics = Topic.approved.with_talks.order(name: :asc)
    @topics = @topics.where("lower(name) LIKE ?", "#{params[:letter].downcase}%") if params[:letter].present?
  end

  def show
    @topic = Topic.find_by!(slug: params[:slug])
  end
end
