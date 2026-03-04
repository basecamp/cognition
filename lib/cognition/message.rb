module Cognition
  class Message
    attr_reader :command, :filter, :metadata, :responder

    def initialize(command, metadata = {})
      @command, @filter = split_on_unquoted_pipe(command).map { |s| s&.strip }
      @metadata = metadata
      @responder = Cognition::Responder.new(metadata["callback_url"]) if metadata["callback_url"]
    end

    def reply(text)
      return "No Callback URL provided" unless @responder
      @responder.reply(text)
    end

    private
      # Splits the input on the first `|` that is not inside double quotes.
      # Returns an array of [command, filter] where filter may be nil.
      def split_on_unquoted_pipe(input)
        in_quotes = false
        input.each_char.with_index do |char, i|
          if char == '"'
            in_quotes = !in_quotes
          elsif char == '|' && !in_quotes
            return [input[0...i], input[i + 1..]]
          end
        end
        [input, nil]
      end
  end
end
