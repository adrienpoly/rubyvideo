class AnalyzeTalkTopicsJob < ApplicationJob
  queue_as :default

  def perform(talk)
    return if talk.raw_transcript.blank?

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        response_format: {type: "json_object"},
        messages: messages(talk)
      }
    )

    raw_response = JSON.repair(response.dig("choices", 0, "message", "content"))
    topics = begin
      JSON.parse(raw_response)["topics"]
    rescue
      []
    end

    topics.map! do |topic|
      Topic.find_or_create_by(name: topic)
    end

    talk.topics = topics.uniq
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
      #{talk.raw_transcript.to_text}
      </transcript>

      3. Read through the entire list of exisiting topics for other talks.
      <topics>
        #{Topic.all.pluck(:name).join(", ")}
      </topics>

      4. Pick 5 to 7 topics that would describe best the talk.
         You can pick any topic from the list of exisiting topics or create a new one.
         if you create a new topic, please ensure that it is relevant to the content of the transcript and match the recommended topics kind.
          - Ruby framework names (examples: Rails, Sinatra, Hanami, Ruby on Rails ...)
          - Ruby gem names
          - Design patterns names (examples: MVC, MVP, Singleton, Observer, Strategy, Command, Decorator, Composite, Facade, Proxy, Mediator, Memento, Observer, State, Template Method, Visitor)
          - Database names (examples: PostgreSQL, MySQL, MongoDB, Redis, Elasticsearch, Cassandra, CouchDB, Sqlite)
          - front end frameworks names (examples: React, Vue, Angular, Ember, Svelte, Stimulus, Preact, Hyperapp, Inferno, Solid, Mithril, Riot, Polymer, Web Components, Hotwire, Turbo, StimulusReflex, Strada ...)
          - front end CSS libraries and framework names (examples: Tailwind, Bootstrap, Bulma, Material UI, Foundation)
          - front end JavaScript libraries names (examples: jQuery, D3, Chart.js, Lodash, Moment.js)
        topics are typically one or two words long, with some exceptions such as "Ruby on Rails"

      5. Format your topics you picked as a JSON object with the following schema:
        {
          "topics": ["topic1", "topic2", "topic3"]
        }

      6. Ensure that your summary is:
        - relevant to the content of the transcript and match the recommended topics kind
        - Free of personal opinions or external information not present in the provided content

      7. Output your JSON object containing the list of topics in the JSON format.
    PROMPT
  end
end
