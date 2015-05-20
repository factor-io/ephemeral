module Ephemeral
  module Resources
    class User < Grape::API

    @@users = {}

      params do
        group :user, type: Hash do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end
      end

      post do
        user_model = Ephemeral::Models::User.new(params)
        @@users[user_model.id] = user_model
        
        present user_model, with:Ephemeral::Entities::User
      end
    end
  end
end