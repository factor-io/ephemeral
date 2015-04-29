require './lib/ephemeral/app/api.rb'
require './lib/ephemeral/app/web.rb'

run Rack::Cascade.new [Ephemeral::API, Ephemeral::Web]