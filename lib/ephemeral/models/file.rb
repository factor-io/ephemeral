require 'securerandom'

module Ephemeral
  module Models
    class File
      attr_accessor :id, :file

      def initialize(file_settings={})
        @id = file_settings[:id] || SecureRandom.hex(8)
        @file = file_settings[:file] || ''
      end
    end
  end
end