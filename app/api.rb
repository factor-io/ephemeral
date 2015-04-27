require 'grape'
require 'sidekiq'

require_relative './worker.rb'
require_relative '../lib/job.rb'
require_relative '../lib/job_entity.rb'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'jobs', size: 1, url:ENV['REDISCLOUD_URL'] }
end

module Ephemeral
  class API < Grape::API
    version 'v1', using: :header, vendor: 'factor'
    format :json
    prefix :api

    resource :jobs do
      desc 'Create a new job'
      params do
        requires :image, type: String, desc: "Docker Image ID"
        requires :commands, type: Array[String], desc: 'List of commands to execute'
        optional :hooks, type: Array do
          requires :event, type: Symbol, values: [:queued, :running, :done, :error], desc: 'Event you want to listen for'
          requires :url, type: String, desc: 'The URL of the web hook.'
        end
        optional :files, type: Array do
          requires :path, type: String, desc:'The absolute path to the file on the host machine'
          optional :content, type: String, desc: 'The string content of the file'
        end
      end
      post do
        job_model = Ephemeral::Job.new
        job_model.status = :queued

        data = Ephemeral::JobEntity.represent(job_model)
        Ephemeral::Worker.perform_async data
        data
      end
    end
  end
end