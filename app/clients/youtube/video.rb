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

      hash = {}
      response.map do |item|
        hash[item["id"]] = {
          view_count: item["statistics"]["viewCount"],
          like_count: item["statistics"]["likeCount"]
        }
      end

      hash
    end
  end
end
