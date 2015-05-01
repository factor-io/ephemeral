
module Ephemeral
  class Framework

    def command
      "sh -c '#{script.join(' && ')}'"
    end
  end
end