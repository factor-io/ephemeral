# encoding: UTF-8

require 'spec_helper'

require_relative '../app/api.rb'

describe Ephemeral::API do
  def app
    Ephemeral::API
  end
  describe 'Jobs' do
    it 'can create' do
      data = {
        image: 'ubuntu',
        commands: ['ls'],
        files: [
          {
            path:'/foo',
            content: 'echo "Hello World!"'
          }
        ]
      }
      post '/api/jobs', data

      expect(last_response.status).to eq(201), JSON.parse(last_response.body)['error']
      body = JSON.parse(last_response.body)
      expect(body.keys).to include('id')
      id = body['id']

      expect(Ephemeral::JobWorker).to have_enqueued_job(id)
    end
  end
end