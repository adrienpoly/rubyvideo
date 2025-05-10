require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ActiveRecord::AssociatedObject.class_eval {
  def self.generates_token(expires_in:, &)
    purpose = attribute_name
    record.generates_token_for(purpose, expires_in:, &)

    define_singleton_method(:find_by_token)  { find_by_token_for(purpose, _1) }
    define_singleton_method(:find_by_token!) { find_by_token_for!(purpose, _1) }

    define_method(:token) { record.generate_token_for(purpose) }
  end
}

module Rubyvideo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    config.autoload_lib(ignore: %w[assets tasks protobuf])

    config.active_job.queue_adapter = :solid_queue
    config.solid_queue.connects_to = {database: {writing: :queue}}

    # to remove once encrytion completed
    config.active_record.encryption.support_unencrypted_data = true

    # disable Mission Control auth as we use the route Authenticator
    config.mission_control.jobs.http_basic_auth_enabled = false
  end
end
