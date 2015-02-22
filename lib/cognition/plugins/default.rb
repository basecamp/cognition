module Cognition
  module Plugins
    class Default < Cognition::Plugins::Base
      match(/^ping/i, 'ping: Returns "PONG"', :pong)
      match(/^help\s*(?<command>.*)/i, 'help: Returns help text for registered plugins', :help)

      def pong(*)
        'PONG'
      end

      def help(msg)
        if msg.matches["command"].empty?
          Cognition.help.join("\n")
        else
          Cognition.help.find_all { |text| text.match msg.matches[:command] }.join("\n")
        end
      end
    end
  end
end
