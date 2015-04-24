require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'jobs', url:ENV['REDISCLOUD_URL'] }
end

module Ephemeral
  class Worker
    include Sidekiq::Worker

    def perform(options)

    end
  end
end