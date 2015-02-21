module Cognition
  class Message
    attr_reader :command, :metadata

    def initialize(command, metadata = {})
      @command = command
      @metadata = metadata
    end
  end
end
