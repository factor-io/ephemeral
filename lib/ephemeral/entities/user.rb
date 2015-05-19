require 'grape-entity'

module Ephemeral
  module Entities
    class User < Grape::Entity
        expose :email
    end
  end
end