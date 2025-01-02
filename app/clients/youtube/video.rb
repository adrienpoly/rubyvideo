module Youtube
  class Video < Client
    def get_statistics(video_id)
      path = "/videos"
      query = {
        part: "statistics",
        id: video_id
      }

      response = all_items(path, query: query)

      return unless response.present?

      {
        view_count: response.first["statistics"]["viewCount"],
        like_count: response.first["statistics"]["likeCount"]
      }
    end

    def duration(video_id)
      path = "/videos"
      query = {
        part: "contentDetails",
        id: video_id
      }

      response = all_items(path, query: query)

      response&.first&.dig("contentDetails", "duration")
    end
  end
end
