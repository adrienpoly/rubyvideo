require "test_helper"

class TopicTest < ActiveSupport::TestCase
  test "create_from_list" do
    topics = ["Rails", "Ruby", "Rails on Rails"]
    statuses = ["pending", "approved", "rejected"]

    statuses.each do |status|
      Topic.create_from_list(topics, status: status)
      assert_equal status, Topic.last.status
    end
  end

  test "create_from_list with duplicated topics" do
    topics = ["Rails", "Rails", "Ruby", "Rails on Rails"]

    assert_changes "Topic.count", 3 do
      Topic.create_from_list(topics)
    end
  end
end
