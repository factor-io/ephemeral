# encoding: UTF-8

require 'spec_helper'

require_relative '../app/api.rb'

describe Ephemeral::API do
  def app
    Ephemeral::API
  end
  
  describe 'Jobs' do
    it 'can create' do
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
      post '/api/jobs', request_data
      
      response_data = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201), response_data['error']
      expect(response_data.keys).to include('id')
      expect(response_data.keys).to include('status')

      expect(Ephemeral::Worker).to have_enqueued_job(response_data)
    end
  end


  describe 'Build' do
    it 'can create' do 
      request_build = {
        image: 'ruby2.1',
        repo: '',
        build_type: 'middleman'
      }
      post '/api/build', request_build

      response_build = JSON.parse(last_response.body)

      expect(last_response.status).to eq(201), response_build['error']
      expect(response_build.keys).to include('id')
      expect(response_build.keys).to include('status')

      expect(Ephemeral::Worker).to have_enqueued_job(response_build)
    end
  end
end
