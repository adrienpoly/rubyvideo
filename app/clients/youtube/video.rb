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

      response.each_with_object({}) do |item, hash|
        hash[item["id"]] = {
         view_count: item["statistics"]["viewCount"],
         like_count: item["statistics"]["likeCount"]
        }
      end
    end
  end
end
