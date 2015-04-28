# encoding: UTF-8

require 'spec_helper'

require_relative '../../lib/ephemeral/providers/tutum.rb'

describe Ephemeral::Providers::TutumProvider do
  before do
    @username = ENV['TUTUM_USERNAME']
    @api_key  = ENV['TUTUM_API_KEY']
  end

  describe :initialize do
    it 'fails without commands' do
      expect {
        Ephemeral::Providers::TutumProvider.new(username:@username,api_key:@api_key)
      }.to raise_error(ArgumentError, 'Command (:command) is required')
    end

    it 'fails without a username' do
      expect {
        Ephemeral::Providers::TutumProvider.new(api_key:@username, command:'ls -al')
      }.to raise_error(ArgumentError, 'Username (:username) is required')
    end

    it 'fails without an api_key' do
      expect {
        Ephemeral::Providers::TutumProvider.new(username: @username, command:'ls -al')
      }.to raise_error(ArgumentError, 'API Key (:api_key) is required')
    end

    it 'can initialize' do 
      expect {
        settings = {api_key: @api_key, username: @username, command:'ls -al'}
        Ephemeral::Providers::TutumProvider.new(settings)
      }.to_not raise_error
    end
  end

  describe :build do
    before do
      @tutum_client = Tutum.new(@username, @api_key)
    end


    it 'can start a build' do
      params = {
        api_key: @api_key,
        username: @username,
        command: 'ls -al'
      }
      provider = Ephemeral::Providers::TutumProvider.new(params)

      response = provider.start

      expect(response).to be_a(Hash)
      expect(response['uuid']).to eq(provider.service_id)
      expect(response['run_command']).to eq(provider.command)
      expect(response['state']).to eq('Not running').or eq('Starting').or eq('Running')
      expect(response['image_name']).to eq(provider.image)
      expect(response['container_size']).to eq(provider.size)
      expect(response['name']).to eq(provider.name)

      begin
        sleep 5
      end while !provider.can_stop?

      @tutum_client.services.terminate(provider.service_id)
    end

    it 'can get logs' do
      params = {
        api_key: @api_key,
        username: @username,
        command: 'ls -al'
      }
      provider = Ephemeral::Providers::TutumProvider.new(params)

      response = provider.start

      # waiting until it finishes running. It is in "Running" state for very short time
      begin
        sleep 5
      end while !provider.stopped?

      logs = provider.logs

      expect(logs).to be_a(String)
      second_line = logs.split("\n")[1]

      expect(second_line).to end_with(' .')

      @tutum_client.services.terminate(provider.service_id)
    end
  end
end