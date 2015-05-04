# encoding: UTF-8

require 'spec_helper'

require_relative '../lib/ephemeral/app/api.rb'

describe Ephemeral::API do
  def app
    Ephemeral::API
  end

  describe 'Builds' do
    describe 'Validation' do 
      it 'validates bad image' do
        request_build = {
          image: 'ruby:2.2',
          repo: 'http://github.com/skierkowski/hello-middleman',
          build_type: 'middleman'
        }

        post '/v1/builds', request_build
        error = JSON.parse(last_response.body)['error']
        expect(last_response.status).to eq(400)
        expect(error).to eq('image does not have a valid value')
      end

      it 'validates bad repo' do
        request_build = {
          image: 'ruby:2.1',
          repo: 'fail',
          build_type: 'middleman'
        }

        post '/v1/builds', request_build
        error = JSON.parse(last_response.body)['error']
        expect(last_response.status).to eq(400)
        expect(error).to eq('repo is invalid')
      end

      it 'validates bad build type' do
        request_build = {
          image: 'ruby:2.1',
          repo: 'http://github.com/skierkowski/hello-middleman',
          build_type: 'not_supported'
        }

        post '/v1/builds', request_build
        error = JSON.parse(last_response.body)['error']
        expect(last_response.status).to eq(400)
        expect(error).to eq('build_type does not have a valid value')
      end
    end

    it 'can create' do 
      request_build = {
        image: 'ruby:2.1',
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
        image: 'ruby:2.1',
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
        image: 'ruby:2.1',
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
