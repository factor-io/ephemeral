require 'grape-entity'

module Ephemeral
  module Entities
    class File < Grape::Entity
      expose :id
      expose :file
    end
  end
end