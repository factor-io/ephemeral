require 'tutum'

require_relative '../provider.rb'

module Ephemeral
  module Providers
    class TutumProvider < Ephemeral::Provider
      attr_accessor :command, :image, :name, :size, :username
      attr_writer :api_key
      attr_reader :id, :service_id
      
      def initialize(options={})
        @id       = SecureRandom.hex(8)
        @image    = options[:image] || 'ubuntu'
        @name     = options[:name]  || "build-#{@id}"
        @size     = options[:size]  || 'XS'
        @command  = options[:command]
        @username = options[:username]
        @api_key  = options[:api_key]
        
        raise ArgumentError, "Command (:command) is required" unless @command
        raise ArgumentError, "Username (:username) is required" unless @username
        raise ArgumentError, "API Key (:api_key) is required" unless @api_key

        @tutum = Tutum.new(@username, @api_key)
      end

      def start
        options = {
          image:                 @image,
          name:                  @name,
          container_size:        @size,
          run_command:           @command,
          target_num_containers: 1
        }
        service     = @tutum.services.create(options)
        @service_id = service['uuid']
        @tutum.services.start(@service_id)
        service
      end

      def status
        @tutum.services.get(@service_id)
      end

      def stop
        raise "Service is not running" unless @service_id
        @tutum.services.stop(@service_id)
        @tutum.services.terminate(@service_id)
      end

      def logs
        @tutum.services.logs(@service_id)
      end
    end
  end
end