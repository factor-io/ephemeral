require 'securerandom'
require 'active_model'

module Ephemeral
  class Job
    include ActiveModel::Model
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON

    attr_accessor :id, :commands, :files, :image, :status

    validates :id, presence: true


    def initialize(settings={})
      @id       = settings[:id] || SecureRandom.hex(8)
      @commands = settings[:commands] || []
      @files    = settings[:files] || []
      @image    = settings[:image] || 'ruby:2.1'
      @status   = :new
    end

    def attributes
      instance_values
    end

    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def work
    end
  end
end