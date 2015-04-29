require 'spec_helper'
require 'securerandom'

require_relative '../app/worker.rb'
require_relative '../lib/ephemeral/models/job.rb'
require_relative '../lib/ephemeral/models/build.rb'

describe Ephemeral::Worker do
  it 'can perform a build' do
    build_settings = {
      'id' =>        "test-#{SecureRandom.hex(4)}",
      'repo' =>      'https://github.com/skierkowski/hello-middleman/archive/master.zip',
      'image' =>     'ruby:2.1',
      'build_type' =>'middleman'
    }
    
    worker = Ephemeral::Worker.new

    response = worker.perform(build_settings)

    expect(response).to be_a(Hash)
    expect(response).to have_key('logs')

  end
end