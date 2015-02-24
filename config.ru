require './app/api.rb'
require './app/web.rb'

run Rack::Cascade.new [Ephemeral::API, Ephemeral::Web]