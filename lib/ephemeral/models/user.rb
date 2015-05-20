require 'securerandom'

module Ephemeral
  module Models
    class User < Sequel::Model

      attr_accessor :id, :email

      def password= password
        self.encrypted_password = Digest::SHA1.hexdigest password
      end

      def initialize(params={})
        @id         = params[:id] || SecureRandom.hex(8)
        @email      = params['user'][:email]
        @password   = params['user'][:password]
      end
    end
  end
end