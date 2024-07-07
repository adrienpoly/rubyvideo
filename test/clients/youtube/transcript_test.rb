require "test_helper"
require "webvtt"

module Youtube
  class TranscriptTest < ActiveSupport::TestCase
    def setup
      @client = Youtube::Transcript.new
    end

    test "fetch the trasncript from a video in vtt format" do
      video_id = "9LfmrkyP81M"

      VCR.use_cassette("youtube_video_transcript", match_requests_on: [:method]) do
        transcript = @client.get_vtt(video_id)
        assert_not_nil transcript

        # Save the VTT content to a temporary file to parse it using WebVTT gem
        Tempfile.create(["transcript", ".vtt"]) do |file|
          file.write(transcript)
          file.rewind

          # Parse the VTT file
          webvtt = WebVTT.read(file.path)

          # Ensure it has the correct headers
          assert_match(/^WEBVTT/, transcript)

          # Ensure it has at least one cue
          assert_not_empty webvtt.cues

          # Validate each cue
          webvtt.cues.each do |cue|
            assert_not_nil cue.start
            assert_not_nil cue.end
            assert_not_nil cue.text
            assert_match(/^\d{2}:\d{2}:\d{2}\.\d{3} --> \d{2}:\d{2}:\d{2}\.\d{3}$/, "#{cue.start} --> #{cue.end}")
          end
        end
      end
    end
  end
end
