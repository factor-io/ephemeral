
module Ephemeral
  module Build
    WORKING_DIR = '/work'
    DEFAULT_LIBS = ['unzip','zip','wget','curl']
    BUILD_SETTINGS = {
      middleman: {
        commands:[
          'bundle install',
          'bundle exec middleman build'
          ],
        libs: ['nodejs'],
        build_path: 'build',
        default_image: 'ruby:2.1'
      }
    }

    def self.script(options = {})
      id         = options[:id]
      repo       = options[:repo]
      type       = options[:type]
      upload_url = options[:upload_url] || "http://ephemeral.io/files/#{id}"
      libs       = options[:libs] || []
      settings   = BUILD_SETTINGS[type.to_sym]
      libs       = settings[:libs] + DEFAULT_LIBS + libs

      commands_setup = [
        'apt-get update',
        "apt-get install -y #{libs.join(' ')} --no-install-recommends",
        "mkdir #{WORKING_DIR}",
        "cd #{WORKING_DIR}",
        "wget #{repo}",
        "unzip *",
        'cd */'
      ]
      commands_upload = [
        "zip -r output.zip #{settings[:build_path]}",
        "curl -v -F \"file=@output.zip\" #{upload_url}"
      ]

      commands = commands_setup + settings[:commands] + commands_upload
      commands
    end

    def self.image(type)
      BUILD_SETTINGS[type][:default_image]
    end
  end
end