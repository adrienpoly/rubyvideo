class Analytics::DashboardsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @daily_visits = Ahoy::Visit.where(started_at: 60.days.ago..).group_by_day(:started_at).count
    @daily_page_views = Ahoy::Event.where(time: 60.days.ago..).group_by_day(:time).count
  end
end
