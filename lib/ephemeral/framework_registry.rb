
frameworks_path = File.join(Dir.pwd.to_s,'lib','ephemeral','frameworks','*.rb')
Dir.glob(frameworks_path).each { |r| require r }

module Ephemeral
  module FrameworkRegistry
    def self.get(id)

      get_class = Ephemeral::Frameworks.constants.find do |class_name|
        begin
          class_obj = Ephemeral::Frameworks.const_get(class_name)
          class_obj.id.to_sym == id.to_sym
        rescue
        end
      end
      raise "No definition found with id #{id}" unless get_class
      Ephemeral::Frameworks.const_get(get_class)
    end
  end
end