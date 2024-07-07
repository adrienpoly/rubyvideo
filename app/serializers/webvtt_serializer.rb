require "webvtt"

class WebVTTSerializer
  def self.dump(transcript)
    return "" if transcript.blank?

    # If transcript is a raw VTT string, convert it to cues first
    transcript = self.load(transcript) if transcript.is_a?(String)

    webvtt = "WEBVTT\n\n"
    transcript.each do |cue|
      webvtt += "#{cue[:start_time]} --> #{cue[:end_time]}\n#{cue[:text]}\n\n"
    end
    webvtt.strip
  end

  def self.load(transcript)
    return [] if transcript.blank?

    cues = []
    # Split transcript by blank lines
    transcript.split("\n\n").each do |block|
      lines = block.split("\n")
      next if lines.size < 2

      timecodes = lines[0].split(" --> ")
      text = lines[1..].join("\n")
      cues << {start_time: timecodes[0], end_time: timecodes[1], text: text}
    end
    cues
  end
end
