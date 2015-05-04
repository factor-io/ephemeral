require 'grape-entity'

module Ephemeral
  module Entities
    class File < Grape::Entity
      expose :file
    end
  end
end