class FeedController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /feed.rss
  # GET /feed.atom
  def index
    @talks = Talk.all.order(created_at: :desc).includes(:speakers).limit(100)

    respond_to do |format|
      format.rss { render layout: false }
      format.atom { render layout: false }
    end
  end
end
