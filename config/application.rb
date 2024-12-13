require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RoRPayments
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq
    config.i18n.default_locale = :"pt-BR"

    config.after_initialize do
      Sidekiq.configure_server do |config|
        config.redis = { url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' } }
      end

      Sidekiq.configure_client do |config|
        config.redis = { url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' } }
      end
    end
  end
end
