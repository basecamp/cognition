module Cognition
  class Matcher
    attr_reader :trigger, :action, :response, :help, :match_data

    def initialize(trigger, help = 'Undocumented', &action)
      raise ArgumentError, 'matcher must have a trigger' unless trigger
      raise ArgumentError, 'matcher must have a action' unless action
      @trigger = trigger
      @help = help
      @action = action
    end

    def attempt(msg)
      return false unless matches?(msg)

      run(msg)
    end

    def run(msg)
      @response = action.call(msg, match_data)
    end

    def matches?(msg)
      case trigger
      when String
        trigger == msg.command
      when Regexp
        @match_data = trigger.match msg.command
      end
    end
  end
end
