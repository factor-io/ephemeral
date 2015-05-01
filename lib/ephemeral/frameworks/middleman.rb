require_relative '../framework'

module Ephemeral
  module Frameworks
    class Middleman < Ephemeral::Framework
      def self.id
        :middleman
      end

      def initialize(options={})
        @version     = options[:ruby_version] || '2.1'
        @source      = options[:source]
        @destination = options[:destination]
        @libs        = options[:libs] || []

        fail "Source (:source) is required" unless @source
        fail "Desintation (:destination) is required" unless @destination
      end

      def script
        default_libs = [ 'unzip','zip','wget','curl', 'nodejs']
        libs         = default_libs + @libs
        working_dir  = '/work'
        build_path   = 'build'

        commands = [
          'apt-get update',
          "apt-get install -y #{libs.join(' ')} --no-install-recommends",
          "mkdir #{working_dir}",
          "cd #{working_dir}",
          "wget #{@source}",
          "unzip *",
          'cd */',
          'bundle install',
          'bundle exec middleman build',
          "zip -r output.zip #{build_path}",
          "curl -v -F \"file=@output.zip\" #{@destination}"
        ]
        commands
      end

      def image
        "ruby:#{@version}"
      end

      private
      def fail(message)
        raise ArgumentError.new(message)
      end
    end
  end
end