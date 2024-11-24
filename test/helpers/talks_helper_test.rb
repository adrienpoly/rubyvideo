require "test_helper"

class TalksHelperTest < ActionView::TestCase
  test "normalize_back_to removes infinite_count and format params" do
    assert_equal "talks_url?s=rails", normalize_back_to("talks_url?s=rails")
    assert_equal "talks_url?s=rails", normalize_back_to("talks_url?s=rails&infinite_count=1")
    assert_equal "talks_url?s=rails", normalize_back_to("talks_url?s=rails&format=turbo_stream")
    assert_equal "talks_url", normalize_back_to("talks_url?format=turbo_stream&page=2")
    assert_equal "talks_url?s=rails", normalize_back_to("talks_url?s=rails&infinite_count=1&format=turbo_stream")
    assert_equal "talks_url?s=rails", normalize_back_to("talks_url?s=rails&infinite_count=111&format=turbo_stream")
  end

  test "normalize_back_to handles empty params" do
    assert_equal "talks_url", normalize_back_to("talks_url")
  end

  test "normalize_back_to preserves other params" do
    result = normalize_back_to("talks_url?topic=ruby&speaker=john&infinite_count=1")
    assert_equal ["speaker=john", "topic=ruby"].sort, URI.parse(result).query.split("&").sort
  end
end
