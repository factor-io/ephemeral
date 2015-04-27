require 'grape-entity'

module Ephemeral
  module Entities
    class Job < Grape::Entity
      expose :id
      expose :commands
      expose :files
      expose :image
      expose :status
    end
  end
end