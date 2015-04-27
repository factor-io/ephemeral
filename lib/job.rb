require 'securerandom'

module Ephemeral
  class Job
    attr_accessor :id, :commands, :files, :image, :status

    def initialize(settings={})
      @id       = settings[:id] || SecureRandom.hex(8)
      @commands = settings[:commands] || []
      @files    = settings[:files] || []
      @image    = settings[:image] || 'ruby:2.1'
      @status   = :new
    end
  end
end