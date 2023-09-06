require "test_helper"

module Youtube
  class VideoTest < ActiveSupport::TestCase
    def setup
      @client = Youtube::Video.new
    end

    test "should return statistics for a valid video" do
      video_id = "9LfmrkyP81M"

      VCR.use_cassette("youtube_statistics", match_requests_on: [:method]) do
        stats = @client.get_statistics(video_id)
        assert_not_nil stats
        assert stats.has_key?(:view_count)
        assert stats.has_key?(:like_count)
      end
    end

    test "should return nil for an invalid video" do
      video_id = "invalid_video_id"

      VCR.use_cassette("youtube_statistics_invalid", match_requests_on: [:method]) do
        stats = @client.get_statistics(video_id)
        assert_nil stats
      end
    end
  end
end
