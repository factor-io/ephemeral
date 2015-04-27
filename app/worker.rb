require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'jobs', url:ENV['REDISCLOUD_URL'] }
end

module Ephemeral
  class Worker
    include Sidekiq::Worker

    def perform(options)
      # Get file using Open-URI
      # Upload to the Docker Provider
      # Run commands
      # Wait for status to finish/change
      # Download files
      # Upload to Ephemeral
    end
  end
end