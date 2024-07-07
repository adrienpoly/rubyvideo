require "message_pb"

module Youtube
  class Transcript
    attr_reader :response

    def get_vtt(video_id)
      message = {one: "asr", two: "en"}
      typedef = MessageType
      two = get_base64_protobuf(message, typedef)

      message = {one: video_id, two: two}
      params = get_base64_protobuf(message, typedef)

      url = "https://www.youtube.com/youtubei/v1/get_transcript"
      headers = {"Content-Type" => "application/json"}
      body = {
        context: {
          client: {
            clientName: "WEB",
            clientVersion: "2.20240313"
          }
        },
        params: params
      }

      @response = HTTParty.post(url, headers: headers, body: body.to_json)
      convert_to_vtt(JSON.parse(response.body))
    end

    def self.get_vtt(video_id)
      new.get_vtt(video_id)
    end

    private

    def encode_message(message, typedef)
      encoded_message = typedef.new(message)
      encoded_message.to_proto
    end

    def get_base64_protobuf(message, typedef)
      encoded_data = encode_message(message, typedef)
      Base64.encode64(encoded_data).delete("\n")
    end

    def convert_to_vtt(transcript)
      vtt_content = "WEBVTT\n\n"
      events = transcript.dig("actions", 0, "updateEngagementPanelAction", "content", "transcriptRenderer", "content", "transcriptSearchPanelRenderer", "body", "transcriptSegmentListRenderer", "initialSegments")
      if events
        events.each_with_index do |event, index|
          segment = event["transcriptSegmentRenderer"]
          start_time = format_time(segment["startMs"].to_i)
          end_time = format_time(segment["endMs"].to_i)
          text = segment.dig("snippet", "runs")&.map { |run| run["text"] }&.join || ""
          vtt_content += "#{index + 1}\n"
          vtt_content += "#{start_time} --> #{end_time}\n"
          vtt_content += "#{text}\n\n"
        end
      else
        vtt_content += "NOTE No transcript data available\n"
      end
      vtt_content
    end

    def format_time(ms)
      hours = ms / (1000 * 60 * 60)
      minutes = (ms % (1000 * 60 * 60)) / (1000 * 60)
      seconds = (ms % (1000 * 60)) / 1000
      milliseconds = ms % 1000
      format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    end
  end
end
