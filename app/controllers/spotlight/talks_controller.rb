class Spotlight::TalksController < ApplicationController
  disable_analytics
  skip_before_action :authenticate_user!

  def index
    @talks = Talk.with_essential_card_data
    @talks = @talks.ft_search(search_query).ranked if search_query.present?
    @talks_count = @talks.count(:id)
    @talks = @talks.limit(5)
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
