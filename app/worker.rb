require 'sidekiq'
require_relative '../lib/ephemeral/models/build_script'
require_relative '../lib/ephemeral/providers/tutum'
Sidekiq.configure_server do |config|
  config.redis = { namespace: 'jobs', url:ENV['REDISCLOUD_URL'] }
end

module Ephemeral
  class Worker
    include Sidekiq::Worker

    def perform(options)
      username   = ENV['TUTUM_USERNAME']
      api_key    = ENV['TUTUM_API_KEY']
      id         = options[:id]
      repo       = options[:repo]
      build_type = options[:build_type]
      commands   = Ephemeral::Build.script(id:id, repo:repo, type:build_type)
      image      = options[:image] || Ephemeral::Build.image(build_type)
      command    = "sh -c '#{commands.join(' && ')}'"
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