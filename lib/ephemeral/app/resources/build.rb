module Ephemeral
  module Resources
    class Build < Grape::API
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
