# encoding: UTF-8

require 'spec_helper'

require_relative '../lib/ephemeral/app/api.rb'

describe Ephemeral::API do
  def app
    Ephemeral::API
  end
<<<<<<< HEAD
  

  request_data = {
    image: 'ubuntu',
    commands: ['ls'],
    files: [
      {
        path:'/foo',
        content: 'echo "Hello World!"'
      }
    ]
  }

  describe 'Jobs' do
    it 'can create' do

      post '/v1/jobs', request_data
      
      response_data = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201), response_data['error']
      expect(response_data.keys).to include('id')
      expect(response_data.keys).to include('status')


      expect(Ephemeral::Worker).to have_enqueued_job(response_data)
    end
  end

=======
>>>>>>> a5a5d294f4ad9760728fea204dbe22bdae48c8b0

  request_build = {
    image: 'ruby:2.1',
    repo: 'http://github.com/skierkowski/hello-middleman',
    build_type: 'middleman'
  }


  describe 'Builds' do
    it 'can create' do 

      post '/v1/builds', request_build

      response_build = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201), response_build['error']
      expect(response_build.keys).to include('id')
      expect(response_build.keys).to include('status')
      expect(response_build.keys).to_not be nil

      expect(Ephemeral::Worker).to have_enqueued_job(response_build)
    end
  end
end
