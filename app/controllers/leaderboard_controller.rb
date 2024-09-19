class LeaderboardController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @filter = params[:filter] || "all_time"
    @ranked_speakers = Speaker.left_joins(:talks)
      .group(:id)
      .order("COUNT(talks.id) DESC")
      .select("speakers.*, COUNT(talks.id) as talk_count")

    if @filter == "last_12_months"
      @ranked_speakers = @ranked_speakers.where("talks.date >= ?", 12.months.ago.to_date)
    end

    @ranked_speakers = @ranked_speakers.limit(100)
  end
end
