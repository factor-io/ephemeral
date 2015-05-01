require 'grape'


require_relative './worker.rb'
require_relative '../models/job.rb'
require_relative '../entities/job.rb'
require_relative '../models/build.rb'
require_relative '../entities/build.rb'
require_relative './resources/build.rb'
require_relative './resources/job.rb'

module Ephemeral
  class API < Grape::API
    version 'v1', vendor: 'factor'
    format :json

    group(:jobs) { mount Ephemeral::Resources::Job }
    group(:builds) { mount Ephemeral::Resources::Build }
  end
end
