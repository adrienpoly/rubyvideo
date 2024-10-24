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

  def yearly_talks
    @yearly_talks = Rails.cache.fetch(["yearly_talks", Talk.all]) do
      Talk.group_by_year(:date).count.map { |date, count| [date.year, count] }
    end
  end

  def speaking_experience
    @speaking_experience = Rails.cache.fetch(["speaking_experience", Talk.all]) do
      Talk
        .joins(:speakers)
        .group("speakers.id")
        .select("speakers.id, MIN(talks.date) AS first_talk_date")
        .group_by { |talk| (Date.today - talk.first_talk_date.to_date).to_i / 365 }
        .transform_keys { |years| "#{years} #{"year".pluralize(years)} of experience" }
        .transform_values(&:count)
        .sort_by { |years, _count| years.to_i }
    end
  end

  def yearly_first_time_speakers
    @yearly_first_time_speakers = Rails.cache.fetch(["yearly_first_time_speakers", Talk.all]) do
      Talk
        .joins(:speakers)
        .group("speakers.id")
        .select("MIN(talks.date) AS first_talk_date")
        .group_by { |talk| Date.parse(talk.first_talk_date).year }
        .transform_values(&:count)
    end
  end

  def yearly_speakers
    @yearly_speakers = Rails.cache.fetch(["yearly_speakers", Talk.all]) do
      Talk
        .joins(:speakers)
        .group("strftime('%Y', talks.date)")
        .count
    end
  end

  def yearly_unique_speakers
    @yearly_unique_speakers = Rails.cache.fetch(["yearly_unique_speakers", Talk.all]) do
      Talk
        .joins(:speakers)
        .group("strftime('%Y', talks.date)")
        .distinct
        .count("speakers.id")
    end
  end
end
