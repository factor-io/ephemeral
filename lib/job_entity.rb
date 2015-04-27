require 'grape-entity'

module Ephemeral
  class JobEntity < Grape::Entity
    expose :id
    expose :commands
    expose :files
    expose :image
    expose :status
  end
end