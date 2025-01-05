class Recurring::RollupJob < ApplicationJob
  queue_as :low

  def perform(*args)
    Ahoy::Visit.rollup("ahoy_daily_visits")
  end
end
