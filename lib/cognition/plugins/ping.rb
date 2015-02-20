module Cognition
  module Plugins
    class Ping < Cognition::Plugins::Base
      def pong(_msg)
        'PONG'
      end

      match(/ping/i, 'ping: Returns "PONG"', :pong)
    end
  end
end
