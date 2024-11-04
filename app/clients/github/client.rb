module GitHub
  class Client < ApplicationClient
    BASE_URI = "https://api.github.com"

    def initialize
      super
    end

    private

    def authorization_header
      token ? {"Authorization" => "Bearer #{token}"} : {}
    end

    def content_type
      "application/vnd.github+json"
    end

    def token
      Rails.application.credentials.github&.dig(:token) || ENV["RUBYVIDEO_GITHUB_TOKEN"]
    end
  end
end
