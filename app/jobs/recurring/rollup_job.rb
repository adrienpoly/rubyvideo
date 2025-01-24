class Recurring::RollupJob < ApplicationJob
  queue_as :low

  def perform(*args)
    Ahoy::Visit.rollup("ahoy_visits", interval: :day)
    Ahoy::Visit.rollup("ahoy_visits", interval: :month)
    Ahoy::Event.rollup("ahoy_events", interval: :day)
    Ahoy::Event.rollup("ahoy_events", interval: :month)
    Talk.rollup("talks", interval: :year, column: :date)
  end
end
