module Ephemeral
  module Resources
    class Build < Grape::API

      @@builds = {}

      desc 'Creates a new build'
      params do
        requires :image, type: String, desc: 'Docker Image ID'
        requires :repo, type: String, desc: 'URL of target repository'
        requires :build_type, type: String, desc: 'Middle ware'
      end

      post do 
        build_model = Ephemeral::Models::Build.new(params)
        build_model.status = :queued

        @@builds[build_model.id] = build_model

        data = Ephemeral::Entities::Build.represent(build_model)
        Ephemeral::Worker.perform_async data
        
        present build_model, with:Ephemeral::Entities::Build
      end

      route_param :id do
        get do
          id = params[:id]
          build_model = @@builds[id]
          
          present build_model, with:Ephemeral::Entities::Build
        end

        put do 
          id = params[:id]
          build_model = @@builds[id]

          build_model.update(params)
          @@builds[build_model.id] = build_model          

          present build_model, with: Ephemeral::Entities::Build
        end
      end
    end
  end
end
