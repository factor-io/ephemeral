require 'grape'

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
        optional :hooks, type: Array[Hash] do
          requires :event, type: Symbol, values: [:queued, :running, :done, :error]
          requires :url, type: String
        end
        optional :files, type: Array[Hash] do
          requires :path, type: String, desc:'The absolute path to the file on the host machine'
          optional :file_url, type: String, desc: 'URL to the file which will be placed in the host'
          optional :file, type: File, desc: 'The file you are uploading'
          exactly_one_of :file_url, :file
        end
      end
      post do
        {cool: 'right'}
      end

    end

  end
end