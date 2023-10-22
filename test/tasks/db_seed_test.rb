require "test_helper"

class DbSeedTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
    Rails.application.load_tasks
    Rake::Task["db:environment:set"].reenable
    Rake::Task["db:schema:load"].invoke
  end

  test "db:seed runs successfully" do
    assert_nothing_raised do
      Rake::Task["db:seed"].invoke
    end

    # ensure that all talks have a year
    assert_equal Talk.where(year: nil).count, 0

    # Ensuring idempotency
    assert_no_difference "Talk.maximum(:created_at)" do
      Rake::Task["db:seed"].reenable
      Rake::Task["db:seed"].invoke
    end
  end
end
