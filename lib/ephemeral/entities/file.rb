require 'grape-entity'

module Ephemeral
  module Entities
    class File < Grape::Entity
      expose :id
      expose :type
      expose :name
    end
  end
end