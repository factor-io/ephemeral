require 'sidekiq'
require_relative '../framework_registry'
require_relative '../providers/tutum'

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'jobs', url:ENV['REDISCLOUD_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'jobs', size: 1, url:ENV['REDISCLOUD_URL'] }
end

module Ephemeral
  class Worker
    include Sidekiq::Worker

    def perform(options)
      username   = ENV['TUTUM_USERNAME']
      api_key    = ENV['TUTUM_API_KEY']
      id         = options['id']
      repo       = options['repo']
      build_type = options['build_type']

      framework_class = Ephemeral::FrameworkRegistry.get(build_type)
      framework = framework_class.new(source:repo,destination:"http://ephemeral.io/files/#{id}")

      image      = framework.image
      command    = framework.command
      settings   = {
        api_key:  api_key,
        username: username,
        command:  command,
        image:    image
      }
      client = Ephemeral::Providers::TutumProvider.new(settings)

      client.start

      begin
        sleep 1
      end while !client.stopped?
      
      info = client.status.merge('logs' => client.logs)

      client.stop

      info
    end
  end
end