class AnalyzeTalkTopicsJob < ApplicationJob
  queue_as :default

  def perform(talk)
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        response_format: {type: "json_object"},
        messages: messages(talk)
      }
    )

    puts response.inspect

    topics = JSON.parse(response.dig("choices", 0, "message", "content"))["topics"] rescue []

    topics = Topic.where(name: topics)

    talk.topics = topics
    talk.save!

    talk
  end

  private

  def client
    OpenAI::Client.new
  end

  def messages(talk)
    [
      {role: "system", content: "You are a helpful assistant skilled in assigned a list of predefined topics to a transcript."},
      {role: "user", content: prompt(talk)}
    ]
  end

  def prompt(talk)
    <<~PROMPT
      You are tasked with figuring out of the list of provided topics matches a transcript based on the transcript and its metadata. Follow these steps carefully:

      1. First, review the metadata of the video:
      <metadata>
        - title: #{talk.title}
        - desciption: #{talk.description}
        - speaker name: #{talk.speakers.map(&:name).to_sentence}
        - event name: #{talk.event_name}
      </metadata>

      2. Next, carefully read through the entire transcript:
      <transcript>
      #{talk.transcript.to_text}
      </transcript>

      3. Look at the list of comma-seprated topics:
      <topics>
        #{Topic.all.pluck(:name).join(", ")}
      </topics>

      4. Pick the topics that match the provided transcript and it's metadata

      5. Format your topics you picked as a JSON object with the following schema:
        {
          "topics": ["topic1", "topic2", "topic3"]
        }

      7. Ensure that your summary is:
        - Objective and factual, based solely on the content of the transcript and metadata
        - Free of personal opinions or external information not present in the provided content

      8. Output your JSON object containing the summary, ensuring it is properly formatted and enclosed in <answer> tags.
    PROMPT
  end
end
