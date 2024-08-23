require "test_helper"

class DbSeedTest < ActiveSupport::TestCase
  test "db:seed runs successfully" do
    skip "TODO: Figure out how to load development seeds"
    Rails.application.load_seed

    # ensure that all talks have a year
    assert_empty Talk.where(date: nil).pluck(:title)

    # Ensuring idempotency
    assert_no_difference "Talk.maximum(:created_at)" do
      Rails.application.load_seed
    end
  end
end
