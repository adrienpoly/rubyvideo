class Talks::RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_talk, only: %i[index]

  def index
    @talks = @talk.related_talks
  end

  private

  def set_talk
    @talk = Talk.find_by(slug: params[:talk_slug])
  end
end
