class Spotlight::SpeakersController < ApplicationController
  skip_before_action :authenticate_user!
  include Pagy::Backend

  def index
    @speakers = Speaker.canonical
    @speakers = @speakers.where("lower(name) LIKE ?", "%#{search_query.downcase}%") if search_query.present?
    @speakers_count = @speakers.count
    @speakers = @speakers.limit(5)
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
