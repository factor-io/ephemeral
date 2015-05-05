require 'securerandom'

module Ephemeral
  module Models
    class File
      attr_accessor :id, :file, :type, :name

      def initialize(params={})
        @id   = params[:id] || SecureRandom.hex(8)
        @file = params['file'][:tempfile].read
        @type = params['file'][:type]
        @name = params['file'][:filename]
      end
    end
  end
end