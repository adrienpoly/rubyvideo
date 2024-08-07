class Transcript
  include Enumerable

  attr_reader :cues

  def initialize(cues: [])
    @cues = cues
  end

  def add_cue(cue)
    @cues << cue
  end

  def to_h
    @cues.map { |cue| cue.to_h }
  end

  def to_json
    to_h.to_json
  end

  def to_text
    @cues.map { |cue| cue.text }.join("\n\n")
  end

  def to_vtt
    vtt_content = "WEBVTT\n\n"
    @cues.each_with_index do |cue, index|
      vtt_content += "#{index + 1}\n"
      vtt_content += "#{cue}\n\n"
    end
    vtt_content
  end

  def presence
    @cues.any? ? self : nil
  end

  def present?
    @cues.any?
  end

  def each(&)
    @cues.each(&)
  end

  class << self
    def create_from_youtube_transcript(youtube_transcript)
      transcript = Transcript.new
      events = youtube_transcript.dig("actions", 0, "updateEngagementPanelAction", "content", "transcriptRenderer", "content", "transcriptSearchPanelRenderer", "body", "transcriptSegmentListRenderer", "initialSegments") || []
      events.each do |event|
        segment = event["transcriptSegmentRenderer"]
        start_time = format_time(segment["startMs"].to_i)
        end_time = format_time(segment["endMs"].to_i)
        text = segment.dig("snippet", "runs")&.map { |run| run["text"] }&.join || ""
        transcript.add_cue(Cue.new(start_time: start_time, end_time: end_time, text: text))
      end
      transcript
    end

    def create_from_json(json)
      transcript = Transcript.new
      json.map(&:symbolize_keys!)
      json.each do |cue_hash|
        transcript.add_cue(Cue.new(start_time: cue_hash[:start_time], end_time: cue_hash[:end_time], text: cue_hash[:text]))
      end
      transcript
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
