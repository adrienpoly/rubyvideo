if ENV["OPENAI_ACCESS_TOKEN"].present?
  OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  end
end
