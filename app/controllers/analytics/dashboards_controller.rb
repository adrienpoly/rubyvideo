class Analytics::DashboardsController < ApplicationController
  skip_before_action :authenticate_user!

  def daily_visits
    @daily_visits = Rails.cache.fetch("daily_visits", expires_at: Time.current.end_of_day) do
      Ahoy::Visit.where("date(started_at) BETWEEN ? AND ?", 60.days.ago.to_date, Date.yesterday).group_by_day(:started_at).count
    end
  end

  def daily_page_views
    @daily_page_views = Rails.cache.fetch("daily_page_views", expires_at: Time.current.end_of_day) do
      Ahoy::Event.where("date(time) BETWEEN ? AND ?", 60.days.ago.to_date, Date.yesterday).group_by_day(:time).count
    end
  end

  def monthly_visits
    @monthly_visits = Rails.cache.fetch("monthly_visits", expires_at: Time.current.end_of_day) do
      Ahoy::Visit.where("date(started_at) BETWEEN ? AND ?", 12.months.ago.to_date.beginning_of_month, Date.yesterday).group_by_month(:started_at).count
    end
  end

  def monthly_page_views
    @monthly_page_views = Rails.cache.fetch("monthly_page_views", expires_at: Time.current.end_of_day) do
      Ahoy::Event.where("date(time) BETWEEN ? AND ?", 12.months.ago.to_date.beginning_of_month, Date.yesterday).group_by_month(:time).count
    end
  end
end
