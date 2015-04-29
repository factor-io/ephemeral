# encoding: UTF-8

require 'spec_helper'

require_relative '../app/web.rb'

describe 'Web' do
	include Rack::Test::Methods

	def app
		Ephemeral::Web.new
	end

	it "has a home" do
		get '/'
		expect(last_response).to be_ok
	end
end
