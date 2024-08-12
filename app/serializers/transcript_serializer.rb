class TranscriptSerializer
  def self.dump(transcript)
    raise "Transcript is not a valid object" unless transcript.is_a?(Transcript)

    transcript.to_json
  end

  def self.load(transcript_json)
    transcript = Transcript.new
    return transcript if transcript_json.nil? || transcript_json.empty?

    cues_array = JSON.parse(transcript_json, symbolize_names: true)
    cues_array.each do |cue_hash|
      transcript.add_cue(Cue.new(start_time: cue_hash[:start_time], end_time: cue_hash[:end_time], text: cue_hash[:text]))
    end
    transcript
  end
end
