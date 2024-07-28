# require "active_support/core_ext/hash/keys"

# This class is used to extract the metadata from a youtube video
# it will try to:
# - extract the speakers from the title
# - remove the event_name from the title to make less redondant
# - remove leading separators from the title
module Youtube
  class NullParser
    def initialize(metadata:, event_name:, options: {})
      @metadata = metadata
      @event_name = event_name
    end

    def cleaned
      OpenStruct.new(
        {
          title: @metadata.title,
          event_name: @event_name,
          published_at: @metadata.published_at,
          description: @metadata.description,
          video_id: @metadata.video_id
        }
      )
    end
  end
end
