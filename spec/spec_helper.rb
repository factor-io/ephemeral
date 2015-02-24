# encoding: UTF-8

require 'codeclimate-test-reporter'
require 'rspec'
require 'rack/test'
require 'mock_redis'
require 'sidekiq'
require 'rspec-sidekiq'

Sidekiq::Testing.fake!

ENV['RACK_ENV']='test'

CodeClimate::TestReporter.start if ENV['CODECLIMATE_REPO_TOKEN']

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
