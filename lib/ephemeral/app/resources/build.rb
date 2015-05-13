module Ephemeral
  module Resources
    class Build < Grape::API
      URL_REGEX = /^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?$/i

      @@builds = {}

      desc 'Creates a new build'
      params do
        requires :image, type: String, desc: 'Docker Image ID', values: ['ruby:2.1']
        requires :repo, type: String, desc: 'URL of target repository', regexp: URL_REGEX
        requires :build_type, type: String, desc: 'Middle ware', values:['middleman']
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
        
        route_param :logs do
          post do
            id          = params['id']
            log         = params['log']
            build_model = @@builds[id]

            build_model.logs << log
            @@builds[id] = build_model
            {log: log}
          end

          get do
            id          = params['id']
            build_model = @@builds[id]
            build_model.logs
          end
        end
      end
    end
  end
end
