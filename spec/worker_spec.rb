require 'spec_helper'

require_relative '../app/worker.rb'
require_relative '../lib/job.rb'

describe Ephemeral::Worker do
  describe 'perform' do

    job = Ephemeral::Job.new

    worker = Ephemeral::Worker.new

    worker.perform(job)

  end
end