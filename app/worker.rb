require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'jobs' }
end

module Ephemeral
  class JobWorker
    include Sidekiq::Worker

    def perform(id)
    end
  end
end