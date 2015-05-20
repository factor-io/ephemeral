require "spec_helper"
require 'pry'

require_relative '../lib/ephemeral/app/api.rb'


describe "User" do
  include Rack::Test::Methods

  def app
    Ephemeral::API    
  end

  describe "signing up" do
    before do 
      post "/v1/users", user: {
        email: 'test@test.com',
        password: '1234'
      }
    end

    it "creates a user" do
      expect(last_response.body).to include('test@test.com') 
      expect(last_response.status).to eq(201)
    end
  end
end
