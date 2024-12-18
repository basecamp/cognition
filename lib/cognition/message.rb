module Cognition
  class Message
    attr_reader :command, :filter, :metadata, :responder

    def initialize(command, metadata = {})
      @command, @filter = command.split("|").map(&:strip)
      @metadata = metadata
      @responder = Cognition::Responder.new(metadata["callback_url"]) if metadata["callback_url"]
    end

    def reply(text)
      return "No Callback URL provided" unless @responder
      @responder.reply(text)
    end
  end
end
