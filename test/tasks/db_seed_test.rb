require "test_helper"

class DbSeedTest < ActiveSupport::TestCase
  setup do
    @old_lookup_paths = Oaken.lookup_paths.dup
    Oaken.lookup_paths.replace ["db/seeds", "db/seeds/development"]
  end

  teardown do
    Oaken.lookup_paths.replace @old_lookup_paths
  end

  test "db:seed runs successfully" do
    skip "TODO: Figure out how to load development seeds"
    Rails.application.load_seed

    # ensure that all talks have a date
    assert_empty Talk.where(date: nil).pluck(:title)

    # Ensuring idempotency
    assert_no_difference "Talk.maximum(:created_at)" do
      Rails.application.load_seed
    end
  end
end
