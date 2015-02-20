module Cognition
  class Message
    attr_reader :command, :metadata

    def initialize(command, metadata = {})
      @command = command
      @metadata = metadata
      metadata.each do |arg, value|
        define_singleton_method arg do
          value
        end
      end
    end
  end
end
