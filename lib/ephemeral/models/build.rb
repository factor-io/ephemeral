require 'securerandom'

module Ephemeral
	module Models
		class Build
			attr_accessor :id, :image, :repo, :build_type, :status

			def initialize(build_settings={})
				@id         = build_settings[:id] || SecureRandom.hex(8)
				@image      = build_settings[:image] || []
				@repo       = build_settings[:repo] || []
				@build_type = build_settings[:build_type] || 'ruby:2.1'
				@status     = :new
			end
		end
	end
end
