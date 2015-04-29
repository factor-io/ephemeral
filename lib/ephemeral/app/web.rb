require 'sinatra'
require 'haml'

module Ephemeral
  class Web < Sinatra::Base
    get '/' do
      haml :index
    end
  end
end