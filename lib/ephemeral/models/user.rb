require 'securerandom'

module Ephemeral
  module Models
    class User < Sequel::Model

      attr_accessor :id, :email, :password

      def initialize(params={})
        @id         = params[:id] || SecureRandom.hex(8)
        @email      = params['user'][:email]
        @password   = params['user'][:password]
      end
    end
  end
end