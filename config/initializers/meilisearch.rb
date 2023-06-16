MeiliSearch::Rails.configuration = {
  meilisearch_url: Rails.env.local? ? "http://localhost:7700" : "http://91.107.208.207:7700", # example: http://localhost:7700
  meilisearch_api_key: ENV["MEILI_MASTER_KEY"]
}
