OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
  config.organization_id = ENV["OPENAI_ORGANIZATION_ID"]
  config.log_errors = Rails.env.development?
  config.request_timeout = 240
end
