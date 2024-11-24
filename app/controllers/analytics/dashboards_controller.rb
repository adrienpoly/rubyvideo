class Analytics::DashboardsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :admin_required, only: %i[top_referrers top_landing_pages top_searches]

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

  def yearly_talks
    @yearly_talks = Rails.cache.fetch(["yearly_talks", Talk.all]) do
      Talk.group_by_year(:date).count.map { |date, count| [date.year, count] }
    end
  end

  def top_referrers
    @top_referrers = Rails.cache.fetch("top_referrers_2", expires_at: Time.current + 2.seconds) do
      Ahoy::Visit
        .where("date(started_at) BETWEEN ? AND ?", 60.days.ago.to_date, Date.yesterday)
        .where.not(referring_domain: [nil, "", "rubyvideo.dev", "www.rubyvideo.dev"])
        .group(:referring_domain)
        .order(Arel.sql("COUNT(*) DESC"))
        .limit(10)
        .count
    end
  end

  def top_landing_pages
    @top_landing_pages = Rails.cache.fetch("top_landing_pages", expires_at: Time.current.end_of_day) do
      Ahoy::Visit
        .where("date(started_at) BETWEEN ? AND ?", 60.days.ago.to_date, Date.yesterday)
        .where.not(landing_page: [nil, ""])
        .group(:landing_page)
        .order(Arel.sql("COUNT(*) DESC"))
        .limit(20)
        .count
        .map do |landing_page, count|
        uri = URI.parse(landing_page)
        [uri.path, count]
      end
        .group_by { |path, _| path }
        .transform_values { |entries| entries.sum { |_, count| count } }
        .to_a
        .sort_by { |_, count| -count }
        .first(10)
    end
  end

  def top_searches
    # @top_searches = Rails.cache.fetch("top_searches", expires_at: Time.current.end_of_day) do
      @top_searches = Ahoy::Event
        .where("date(time) BETWEEN ? AND ?", 60.days.ago.to_date, Time.current)
        .where(name: "talks#index")
        .pluck(:properties)
        .map { |properties| properties["s"] }
        .compact
        .tally
        .sort_by { |_, count| -count }
        .first(10)
    # end
    @top_searches
  end

  private

  def admin_required
    redirect_to analytics_dashboards_path unless Current.user&.admin?
  end
end
