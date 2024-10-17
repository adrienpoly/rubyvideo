ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "test/vcr_cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.ignore_hosts "chromedriver.storage.googleapis.com", "googlechromelabs.github.io", "edgedl.me.gvt1.com"
  c.filter_sensitive_data("<OPENAI_API_KEY>") { ENV["OPENAI_ACCESS_TOKEN"] }
  c.filter_sensitive_data("<OPENAI_ORGANIZATION_ID>") { ENV["OPENAI_ORGANIZATION_ID"] }
end
class ActiveSupport::TestCase
  setup do
    @@once ||= begin
      MeiliSearch::Rails::Utilities.reindex_all_models
      true
    end
  end

  if ENV["CI"]
    parallelize(workers: 1)
  else
    parallelize(workers: :number_of_processors)
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def sign_in_as(user)
    post(sign_in_url, params: {email: user.email, password: "Secret1*3*5*"})
    user
  end
end

MeiliSearch::Rails::Utilities.clear_all_indexes
