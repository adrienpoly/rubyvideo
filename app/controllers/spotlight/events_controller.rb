class Spotlight::EventsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @events = Event.canonical
    @events = @events.where("lower(name) LIKE ?", "%#{search_query.downcase}%") if search_query.present?
    @events_count = @events.count
    @events = @events.limit(5)
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
