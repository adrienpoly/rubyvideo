require "test_helper"

class Recurring::RollupJobTest < ActiveJob::TestCase
  test "creates a rollup for today" do
    visit_1 = Ahoy::Visit.create!(started_at: Time.current)
    Ahoy::Event.create!(name: "Some Page during visit_1", visit: visit_1, time: Time.current)
    Recurring::RollupJob.new.perform
    assert_equal 1, Rollup.where(name: "ahoy_daily_visits").count
  end
end
