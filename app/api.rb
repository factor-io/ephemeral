require 'grape'

require_relative './worker.rb'
require_relative '../lib/ephemeral/models/job.rb'
require_relative '../lib/ephemeral/entities/job.rb'
require_relative '../lib/ephemeral/models/build.rb'
require_relative '../lib/ephemeral/entities/build.rb'

module Ephemeral
  class API < Grape::API
    version 'v1', vendor: 'factor'
    format :json

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
        job_model = Ephemeral::Models::Job.new(params)
        job_model.status = :queued

        data = Ephemeral::Entities::Job.represent(job_model)
        Ephemeral::Worker.perform_async data
        data
      end
    end

    resource :builds do

      desc 'Creates a new build'
      params do
        requires :image, type: String, desc: 'Docker Image ID'
        requires :repo, type: String, desc: 'URL of target repository'
        requires :build_type, type: String, desc: 'Middle ware'
      end

      post do 
        build_model = Ephemeral::Models::Build.new(params)
        build_model.status = :queued

        data = Ephemeral::Entities::Build.represent(build_model)
        Ephemeral::Worker.perform_async data
        data
      end
    end
  end
end
