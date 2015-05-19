require "spec_helper"

require_relative '../lib/ephemeral/app/api.rb'

describe "User" do
  include Rack::Test::Methods

  def app
    Ephemeral::API    
  end

  describe "signing up" do

    it "creates a user" do
      request_user = {
        email: 'test@test.com',
        password: '1234'
      }
      post '/v1/users', request_user

      response_user = JSON.parse(last_response.body)
      
      expect(last_response.status).to eq(201)
    end
  end
end
