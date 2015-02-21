module Cognition
  module Plugins
    class Ping < Cognition::Plugins::Base
      match(/ping/i, 'ping: Returns "PONG"', :pong)

      def pong(*)
        'PONG'
      end
    end
  end
end
