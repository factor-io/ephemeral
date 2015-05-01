
require 'pry'
require 'uri'
require 'net/http'

module Ephemeral
  module Resources
    class Build < Grape::API

      
      def initialize
        @builds = {}
      end

      helpers do 
        def log
          Build.logger 
        end

        def url_exist?(repo)
          url = URI.parse(repo)
          req = Net::HTTP.new(url.host, url.port)
          req.use_ssl = (url.scheme == 'https')
          path = url.path if url.path.present?
          res = req.request_head(path || '/')
          if res.kind_of?(Net::HTTPRedirection)
            url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
          else
            ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
          end
        rescue Errno::ENOENT
          false #false if can't find the server
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



        log.info "Parameters: #{params}" 
        log.info "Route info: #{route}"
        url_exist?('http://github.com/skierkowski/hello-middleman')
        data
      end

      put '/build/:id' do
        id = params[:id]
        build_model = @builds[id]
 
 
        build_model.update(params)
        @builds[build_model.id] = build_model
        data = Ephemeral::Entities::Build.represent(build_model)
        data
      end

      get '/build/:id' do
        id = params[:id]
        build_model = @builds[id]
 
        data = Ephemeral::Entities::Build.represent(build_model)

        data

      end
    end
  end
end
