module Talk::TranscriptCommands
  extend ActiveSupport::Concern

  included do
    serialize :enhanced_transcript, coder: TranscriptSerializer
    serialize :raw_transcript, coder: TranscriptSerializer

    # jobs
    performs :enhance_transcript!, queue_as: :low do
      retry_on StandardError, attempts: 3, wait: :polynomially_longer
      limits_concurrency to: 1, key: "openai_api", duration: 1.hour # this is to comply to the rate limit of openai 60 000 tokens per minute
    end

    performs :fetch_and_update_raw_transcript!, queue_as: :low do
      retry_on StandardError, attempts: 3, wait: :polynomially_longer
    end
  end

  def fetch_and_update_raw_transcript!
    youtube_transcript = Youtube::Transcript.get(video_id)
    update!(raw_transcript: Transcript.create_from_youtube_transcript(youtube_transcript))
  end

  def enhance_transcript!
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini", # Required.
        response_format: {type: "json_object"},
        messages: enhance_transcript_messages
      }
    )
    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    enhanced_json_transcript = JSON.parse(raw_response).dig("transcript")
    update!(enhanced_transcript: Transcript.create_from_json(enhanced_json_transcript))
  end

  private

  def enhance_transcript_messages
    [
      {role: "system", content: "You are a helpful assistant skilled in processing and summarizing transcripts."},
      {role: "user", content: enhance_transcript_prompt}
    ]
  end

  def enhance_transcript_prompt
    <<~PROMPT
      You are tasked with improving and formatting a raw VTT transcript. Your goal is to correct and enhance the text, organize it into paragraphs, and format it into a specific JSON structure. Follow these instructions carefully to complete the task.

      First, here is the metadata for the transcript:
        - title: #{title}
        - description: #{description}
        - speaker name: #{speakers.map(&:name).to_sentence}
        - event name: #{event_name}

      Now, let's process the raw VTT transcript. Here's what you need to do:

      1. Read through the entire raw transcript carefully.

      2. Correct any spelling, grammar, or punctuation errors you find in the text.

      3. Improve the overall readability and coherence of the text without changing its meaning.

      4. Group related sentences into paragraphs. Each paragraph should contain a complete thought or topic.

      5. For each paragraph, use the start time of its first sentence as the paragraph's start time, and the end time of its last sentence as the paragraph's end time.

      6. Format the improved transcript into a JSON structure using this schema:
      {"transcript": [{start_time: "00:00:00", end_time: "00:00:05", text: "Hello, world!"},...]}

      Here is the raw VTT transcript to process:

      <raw_transcript>
      #{raw_transcript.to_vtt}
      </raw_transcript>

      To complete this task, follow these steps:

      1. Read through the entire raw transcript.
      2. Make necessary corrections to spelling, grammar, and punctuation.
      3. Improve the text for clarity and coherence.
      4. Group related sentences into paragraphs.
      5. Determine the start and end times for each paragraph.
      6. Format the improved transcript into the specified JSON structure.

      Remember to preserve the original meaning of the content while making improvements. Ensure that each JSON object in the array represents a paragraph with its corresponding start time, end time, and improved text.
    PROMPT
  end

  def client
    OpenAI::Client.new
  end
end
