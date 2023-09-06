class Ai
  def self.embedding(*inputs)
    return nil unless ENV["OPENAI_ACCESS_TOKEN"].present?
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: inputs.join("\n\n")
      }
    )
    response.dig("data", 0, "embedding")
  end
end
