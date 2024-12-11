class Talk::Agents < ActiveRecord::AssociatedObject
  performs :improve_transcript, retries: 3 do
    limits_concurrency to: 1, key: "openai_api", duration: 1.hour # this is to comply to the rate limit of openai 60 000 tokens per minute
  end

  performs :summarize, retries: 3 do
    limits_concurrency to: 1, key: "openai_api", duration: 1.hour # this is to comply to the rate limit of openai 60 000 tokens per minute
  end

  performs :analyze_topics, retries: 3 do
    limits_concurrency to: 1, key: "openai_api", duration: 1.hour # this is to comply to the rate limit of openai 60 000 tokens per minute
  end

  def improve_transcript
    response = client.chat(
      parameters: Prompts::Talk::EnhanceTranscript.new(talk: talk).to_params
    )
    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    enhanced_json_transcript = JSON.parse(raw_response).dig("transcript")
    talk.update!(enhanced_transcript: Transcript.create_from_json(enhanced_json_transcript))
  end

  def summarize
    return unless talk.raw_transcript.present?

    response = client.chat(
      parameters: Prompts::Talk::Summary.new(talk: talk).to_params
    )

    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    summary = JSON.parse(raw_response).dig("summary")
    talk.update!(summary: summary)
  end

  def analyze_topics
    return if talk.raw_transcript.blank?

    response = client.chat(
      parameters: Prompts::Talk::Topics.new(talk: talk).to_params
    )

    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    topics = begin
      JSON.parse(raw_response)["topics"]
    rescue
      []
    end

    talk.topics = Topic.create_from_list(topics)
    talk.save!

    talk
  end

  private

  def client
    OpenAI::Client.new
  end
end
