class Spotlight::SpeakersController < ApplicationController
  disable_analytics
  skip_before_action :authenticate_user!

  def index
    @speakers = Speaker.canonical
    @speakers = @speakers.ft_search(search_query) if search_query.present?
    @speakers_count = @speakers.count
    @speakers = @speakers.limit(8)
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  helper_method :search_query
  def search_query
    params[:s]
  end
end
