require "test_helper"

class TopicTest < ActiveSupport::TestCase
  test "create_from_list" do
    topics = ["Rails", "Ruby", "Ruby on Rails"]
    statuses = ["pending", "approved", "rejected"]

    statuses.each do |status|
      created_topics = Topic.create_from_list(topics, status: status)
      assert_equal [status], created_topics.pluck(:status).uniq
      Topic.where(name: topics).destroy_all
    end
  end

  test "create_from_list shoudln't update status of exiting topic" do
    topic = Topic.create(name: "Ruby on Rails", status: :approved)
    assert_equal "approved", topic.status

    created_topics = Topic.create_from_list([topic.name], status: :pending)

    assert_equal 1, created_topics.length
    assert_equal "approved", created_topics.first.status
  end

  test "create_from_list with duplicated topics" do
    topics = ["Rails", "Rails", "Ruby", "Rails on Rails"]

    assert_changes "Topic.count", 3 do
      Topic.create_from_list(topics)
    end
  end
end
