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
        # files: [ 
        #   {
        #     path: '/test.zip',
        #     file_url:'http://foo.com/test.zip'
        #   }
        # ]
      }
      post '/api/jobs', data

      expect(last_response).to be_ok
    end
  end
end