module Talk::TranscriptCommands
  extend ActiveSupport::Concern

  included do
    serialize :enhanced_transcript, coder: TranscriptSerializer
    serialize :raw_transcript, coder: TranscriptSerializer

    # jobs
    performs :enhance_transcript!, queue_as: :low do
      retry_on StandardError, attempts: 1
    end

    performs :fetch_and_update_raw_transcript!, queue_as: :low do
      retry_on StandardError, wait: :polynomially_longer
    end
  end

  def fetch_and_update_raw_transcript!
    youtube_transcript = Youtube::Transcript.get(video_id)
    update!(raw_transcript: Transcript.create_from_youtube_transcript(youtube_transcript))
  end

  def enhance_transcript!
    response = client.chat(
      parameters: {
        model: "gpt-4o", # Required.
        response_format: {type: "json_object"},
        messages: messages
      }
    )
    enhanced_json_transcript = JSON.parse(response.dig("choices", 0, "message", "content")).dig("transcript")
    update!(enhanced_transcript: Transcript.create_from_json(enhanced_json_transcript))
  end

  private

  def messages
    [
      {role: "system", content: "You are a helpful assistant skilled in processing and summarizing transcripts."},
      {role: "user", content: prompt}
    ]
  end

  def prompt
    <<~PROMPT
      Here is a raw VTT transcript output.
      Correct and improve the entire text and format the improved transcript into a JSON structure with the specified schema

      To help, the metadata for this transcript are:
      - title: #{title}
      - desciption: #{description}
      - speaker name: #{speakers.map(&:name).to_sentence}
      - event name: #{event_name}

      json schema:
      [{start_time: "00:00:00", end_time: "00:00:05", text: "Hello, world!"},....]

      Raw VTT Transcript:
      #{raw_transcript.to_vtt}
    PROMPT
  end

  def client
    OpenAI::Client.new
  end
end
