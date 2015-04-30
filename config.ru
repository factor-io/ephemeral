require './lib/ephemeral/app/api.rb'
require './lib/ephemeral/app/web.rb'

map = {'/' => Rack::Cascade.new([Sinatra::Application, Ephemeral::Web])}



if ENV['RACK_ENV'] != 'production'
  require 'sidekiq/web'
  map['/sidekiq'] = Sidekiq::Web
end

run Rack::URLMap.new(map)