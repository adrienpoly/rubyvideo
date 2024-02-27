require "test_helper"

class FeedControllerTest < ActionDispatch::IntegrationTest
  setup do
    @talks = talks(:one, :two)
    frozen_date_time = DateTime.new(2022, 1, 15, 10, 0, 0)
    @talks.each do |talk|
      talk.update!(created_at: frozen_date_time, updated_at: frozen_date_time)
    end
  end

  test "should get rss format" do
    get feed_url(format: :rss)

    assert_response :success
    assert_equal "/feed.rss", path
    assert_equal "application/rss+xml; charset=utf-8", response.content_type
    assert_equal File.read("test/fixtures/files/feed.rss"), response.parsed_body
  end

  test "should get atom format" do
    get feed_url(format: :atom)

    assert_response :success
    assert_equal "/feed.atom", path
    assert_equal "application/atom+xml; charset=utf-8", response.content_type
    assert_equal File.read("test/fixtures/files/feed.atom"), response.parsed_body
  end
end
