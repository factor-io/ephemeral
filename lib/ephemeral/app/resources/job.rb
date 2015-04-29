module Ephemeral
  module Resources
    class Job < Grape::API
      
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
  end
end
