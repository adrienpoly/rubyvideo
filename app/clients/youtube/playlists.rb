module Youtube
  class Playlists < Youtube::Client
    DEFAULT_METADATA_PARSER = "Youtube::VideoMetadata"
    def all(channel_id:, title_matcher: nil)
      items = all_items("/playlists", query: {channelId: channel_id, part: "snippet,contentDetails"}).map do |metadata|
        OpenStruct.new({
          id: metadata.id,
          title: metadata.snippet.title,
          description: metadata.snippet.description,
          published_at: DateTime.parse(metadata.snippet.publishedAt).to_date.to_s,
          channel_id: metadata.snippet.channelId,
          year: metadata.snippet.title.match(/\d{4}/).to_s.presence || DateTime.parse(metadata.snippet.publishedAt).year,
          videos_count: metadata.contentDetails.itemCount,
          metadata_parser: DEFAULT_METADATA_PARSER,
          slug: metadata.snippet.title.parameterize
        })
      end
      items = items.select { |item| item.title.match?(string_to_regex(title_matcher)) } if title_matcher
      items
    end

    private

    def string_to_regex(str)
      Regexp.new(str, "i")
    end
  end
end
