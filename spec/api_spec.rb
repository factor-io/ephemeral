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
      body_string = last_response.body
      body_hash = JSON.parse(body_string)
      expect(body_hash.keys).to include('id')
      expect(body_hash.keys).to include('status')
      id = body_hash['id']

      job = Ephemeral::Job.new.from_json(body_string)

      expect(Ephemeral::Worker).to have_enqueued_job(job.to_json)
    end
  end
end