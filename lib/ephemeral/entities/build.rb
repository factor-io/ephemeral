require 'grape-entity'

module Ephemeral
  module Entities
    class Build < Grape::Entity
      expose :id
      expose :image
      expose :repo
      expose :build_type
      expose :status
    end
  end
end
