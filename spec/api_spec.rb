# encoding: UTF-8

require 'spec_helper'

require_relative '../lib/ephemeral/app/api.rb'

describe Ephemeral::API do
  def app
    Ephemeral::API
  end

  describe 'Builds' do
    it 'can create' do 
      request_build = {
        image: 'ruby2.2',
        repo: 'http://github.com/skierkowski/hello-middleman',
        build_type: 'middleman'
      }
      post '/v1/builds', request_build

      response_build = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201), response_build['error']
      expect(response_build.keys).to include('id')
      expect(response_build.keys).to include('status')

      expect(Ephemeral::Worker).to have_enqueued_job(response_build)
    end
  end
end
