class Recurring::RollupJob < ApplicationJob
  queue_as :low

  def perform(*args)
    Ahoy::Visit.rollup("ahoy_daily_visits")
    Ahoy::Event.rollup("ahoy_daily_page_views")
  end
end
