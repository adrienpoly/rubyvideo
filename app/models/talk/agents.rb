# -*- SkipSchemaAnnotations
class Talk::Agents < ActiveRecord::AssociatedObject
  performs retries: 3 do
    # this is to comply to the rate limit of openai 60 000 tokens per minute
    limits_concurrency to: 1, key: "openai_api", duration: 1.hour
  end

  performs def improve_transcript
    response = client.chat(
      parameters: Prompts::Talk::EnhanceTranscript.new(talk: talk).to_params
    )
    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    enhanced_json_transcript = JSON.parse(raw_response).dig("transcript")
    transcript = talk.talk_transcript || Talk::Transcript.new
    transcript.update!(enhanced_transcript: ::Transcript.create_from_json(enhanced_json_transcript))
  end

  performs def summarize
    return unless talk.raw_transcript.present?

    response = client.chat(
      parameters: Prompts::Talk::Summary.new(talk: talk).to_params
    )

    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    summary = JSON.parse(raw_response).dig("summary")
    talk.update!(summary: summary)
  end

  performs def analyze_topics
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
