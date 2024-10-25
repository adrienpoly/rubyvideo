meilisearch_url = {
  development: "http://localhost:7700",
  test: "http://localhost:7700",
  production: "http://rubyvideo-search:7700",
  staging: "http://rubyvideo_staging-search:7700"
}[Rails.env.to_sym]

MeiliSearch::Rails.configuration = {
  meilisearch_url: meilisearch_url,
  meilisearch_api_key: Rails.env.local? ? nil : ENV["MEILI_MASTER_KEY"],
  per_environment: true
}
