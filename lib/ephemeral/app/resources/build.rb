module Ephemeral
  module Resources
    class Build < Grape::API

    helpers do 
      def log
        Build.logger 
      end
    end

      desc 'Creates a new build'
      params do
        requires :image, type: String, desc: 'Docker Image ID', values: ['ruby:2.1']
        requires :repo, type: String, desc: 'URL of target repository'
        requires :build_type, type: String, desc: 'Middle ware', values: ['middleman']
      end

      post do 
        build_model = Ephemeral::Models::Build.new(params)
        build_model.status = :queued

        data = Ephemeral::Entities::Build.represent(build_model)
        Ephemeral::Worker.perform_async data
          log.warn "Parameters: #{params}" 
          log.warn "Route info: #{route}"
        data
      end
    end
  end
end
