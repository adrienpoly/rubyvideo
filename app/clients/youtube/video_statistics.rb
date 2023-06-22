module Youtube
  class VideoStatistics < Client
    def list(video_id)
      path = "/videos"
      query = {
        part: "statistics",
        id: video_id
      }

      response = all_items(path, query: query)

      if response.empty?
        puts "Error: No video found with the given ID"
        return nil
      end

      # Assuming there's only one item in the response, as the ID of a video is unique.
      {
        view_count: response.first["statistics"]["viewCount"],
        like_count: response.first["statistics"]["likeCount"]
      }
    end
  end
end
