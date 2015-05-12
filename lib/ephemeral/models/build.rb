require 'securerandom'

module Ephemeral
  module Models
    class Build
      attr_accessor :id, :image, :repo, :build_type, :status

      def initialize(build_settings={})
        @id         = build_settings[:id] || SecureRandom.hex(8)
        @image      = build_settings[:image] || ''
        @repo       = build_settings[:repo] || ''
        @build_type = build_settings[:build_type] || ''
        @status     = :new
        @logs       = build_settings[:logs] || []        
      end

      def update(build_settings={})
        @image      = build_settings[:image] || @image
        @repo       = build_settings[:repo] || @repo
        @build_type = build_settings[:build_type] || @build_type
        @status     = build_settings[:status] || @status || :new
        @logs       = build_settings[:logs] || []     
      end
    end
  end
end

