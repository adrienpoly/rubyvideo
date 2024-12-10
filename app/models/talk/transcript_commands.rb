module Talk::TranscriptCommands
  extend ActiveSupport::Concern

  included do
    serialize :enhanced_transcript, coder: TranscriptSerializer
    serialize :raw_transcript, coder: TranscriptSerializer

    performs :fetch_and_update_raw_transcript!, retries: 3
  end

  def fetch_and_update_raw_transcript!
    youtube_transcript = Youtube::Transcript.get(video_id)
    update!(raw_transcript: Transcript.create_from_youtube_transcript(youtube_transcript))
  end
end
