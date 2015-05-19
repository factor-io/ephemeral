module Ephemeral
  module Resources
    class User < Grape::API

      params do
        group :user, type: Hash do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end
      end

      post do

      end
    end
  end
end