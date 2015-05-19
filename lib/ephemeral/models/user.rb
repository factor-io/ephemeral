require 'securerandom'

module Ephemeral
  module Models
    class User
      attr_accessor :email, :password, :id

      def initialize(params={})
        @id          = user_settings[:id] || SecureRandom.hex(8)
        @email       = user_settings[:email] || ''
        @password    = user_settings[:password] || ''
      end
    end
  end
end