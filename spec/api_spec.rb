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

    it 'can get a build' do
      request_build = {
        image: 'ruby2.2',
        repo: 'http://github.com/skierkowski/hello-middleman',
        build_type: 'middleman'
      }
      create_response = post '/v1/builds', request_build

      id = JSON.parse(create_response.body)['id']

      get_response = get "/v1/builds/#{id}"

      content = JSON.parse(get_response.body)

      expect(content.keys).to include('id')
      expect(content.keys).to include('status')
    end

    it 'can update a build' do
      request_build = {
        image: 'ruby2.2',
        repo: 'http://github.com/skierkowski/hello-middleman',
        build_type: 'middleman'
      }
      create_response = post '/v1/builds', request_build

      id = JSON.parse(create_response.body)['id']

      get_response = put "/v1/builds/#{id}", status:'done'

      content = JSON.parse(get_response.body)

      expect(content['status']).to eq('done')
    end
  end
end
