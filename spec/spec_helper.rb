# encoding: UTF-8

require 'codeclimate-test-reporter'
require 'rspec'
require 'rack/test'

ENV['RACK_ENV']='test'

CodeClimate::TestReporter.start if ENV['CODECLIMATE_REPO_TOKEN']

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
