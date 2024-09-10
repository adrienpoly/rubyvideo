module Github
  class Client < ApplicationClient
    BASE_URI = "https://api.github.com"

    def initialize(token: ENV["RUBYVIDEO_GITHUB_TOKEN"])
      super
    end

    private

    def authorization_header
      token ? {"Authorization" => "Bearer #{token}"} : {}
    end

    def content_type
      "application/vnd.github+json"
    end
  end
end
