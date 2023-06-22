module Youtube
  class Video < Client
    def get_statistics(video_id)
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

      {
        view_count: response.first["statistics"]["viewCount"],
        like_count: response.first["statistics"]["likeCount"]
      }
    end
  end
end
