module Cognition
  module Plugins
    class Default < Cognition::Plugins::Base
      # rubocop:disable Lint/AmbiguousRegexpLiteral
      match /^ping/i, :pong, help: {
        "ping" => "Test if the endpoint is responding. Returns PONG."
      }

      match /^help\s*(?<command>.*)/i, :help, help: {
        "help" => "Lists all commands with help",
        "help <command>" => "Lists help for <command>"
      }
      # rubocop:enable Lint/AmbiguousRegexpLiteral

      def pong(*)
        "PONG"
      end

      def help(msg, match_data = nil)
        type = msg.metadata[:type] ||= "text"
        if match_data[:command].nil? || match_data[:command].empty?
          @help = bot.help
        else
          @help = bot.help.find_all { |text| text.match match_data[:command] }
        end
        render(type: type)
      end
    end
  end
end
