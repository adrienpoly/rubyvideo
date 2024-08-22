require "test_helper"

class DbSeedTest < ActiveSupport::TestCase
  self.use_transactional_tests = false # don't use fixtures for this test

  setup do
    Rails.application.load_tasks
    Rake::Task["db:environment:set"].reenable
    Rake::Task["db:schema:load"].invoke
  end

  test "db:seed runs successfully" do
    assert_nothing_raised do
      Rake::Task["db:seed"].invoke
    end

    # ensure that all talks have a date
    assert_equal Talk.where(date: nil).count, 0

    # Ensuring idempotency
    assert_no_difference "Talk.maximum(:created_at)" do
      Rake::Task["db:seed"].reenable
      Rake::Task["db:seed"].invoke
    end
  end
end
