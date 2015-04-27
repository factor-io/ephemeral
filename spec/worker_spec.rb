require 'spec_helper'

require_relative '../app/worker.rb'
require_relative '../lib/ephemeral/models/job.rb'

describe Ephemeral::Worker do
  describe 'perform' do
    job    = Ephemeral::Models::Job.new
    data   = JSON.parse(Ephemeral::Entities::Job.represent(job).to_json)
    worker = Ephemeral::Worker.new

    worker.perform(data)

  end
end