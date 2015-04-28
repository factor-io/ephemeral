# encoding: UTF-8

require 'spec_helper'

require_relative '../../lib/ephemeral/providers/tutum.rb'

describe Ephemeral::Providers::TutumProvider do
  before do
    @tutum_username = ENV['TUTUM_USERNAME']
    @tutum_api_key  = ENV['TUTUM_API_KEY']
  end

  describe :initialize do
    it 'fails without commands' do
      expect {
        Ephemeral::Providers::TutumProvider.new(username:@tutum_username,api_key:@tutum_api_key)
      }.to raise_error(ArgumentError, 'Command (:command) is required')
    end

    it 'fails without a username' do
      expect {
        Ephemeral::Providers::TutumProvider.new(api_key:@tutum_username, command:'ls -al')
      }.to raise_error(ArgumentError, 'Username (:username) is required')
    end

    it 'fails without an api_key' do
      expect {
        Ephemeral::Providers::TutumProvider.new(username: @tutum_username, command:'ls -al')
      }.to raise_error(ArgumentError, 'API Key (:api_key) is required')
    end

    it 'can initialize' do 
      expect {
        settings = {api_key: @tutum_api_key, username: @tutum_username, command:'ls -al'}
        Ephemeral::Providers::TutumProvider.new(settings)
      }.to_not raise_error
    end
  end
end