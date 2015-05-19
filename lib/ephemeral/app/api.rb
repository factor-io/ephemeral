require 'grape'

require_relative './worker.rb'
require_relative '../models/build.rb'
require_relative '../entities/build.rb'
require_relative './resources/build.rb'
require_relative '../models/file.rb'
require_relative '../entities/file.rb'
require_relative './resources/file.rb'
require_relative '../models/user.rb'
require_relative '../entities/user.rb'
require_relative './resources/user.rb'

module Ephemeral
  class API < Grape::API
    version 'v1', vendor: 'factor'
    format :json

    group(:builds) { mount Ephemeral::Resources::Build }
    group(:files)  { mount Ephemeral::Resources::File }
  end
end
