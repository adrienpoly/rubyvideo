class LeaderboardController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @filter = params[:filter] || "all_time"
    @ranked_speakers = Speaker.left_joins(:talks)
      .group(:id)
      .order("COUNT(talks.id) DESC")
      .select("speakers.name, speakers.github, speakers.id, speakers.slug, COUNT(talks.id) as talks_count")

    if @filter == "last_12_months"
      @ranked_speakers = @ranked_speakers.where("talks.date >= ?", 12.months.ago.to_date)
    end
    @ranked_speakers = @ranked_speakers.limit(100)
    last_modified_talk = Talk.order(updated_at: :desc).first
    fresh_when(last_modified: last_modified_talk&.updated_at || Time.current)
  end
end
