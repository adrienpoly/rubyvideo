module Github
  class Client < ApplicationClient
    BASE_URI = "https://api.github.com"

    private

    def token
      ENV["GITHUB_TOKEN"]
    end

    def content_type
      "application/vnd.github+json"
    end
  end
end
