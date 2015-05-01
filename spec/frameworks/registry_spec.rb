# encoding: UTF-8

require 'spec_helper'

require_relative '../../lib/ephemeral/framework_registry.rb'

describe Ephemeral::FrameworkRegistry do
  
  it 'can find a framework by id' do
    middleman = Ephemeral::FrameworkRegistry.get(:middleman)
    expect(middleman).to eq(Ephemeral::Frameworks::Middleman)
  end
end
