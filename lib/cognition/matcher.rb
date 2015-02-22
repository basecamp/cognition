module Cognition
  class Matcher
    attr_accessor :trigger, :action, :response, :help

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
      @response = action.call(msg)
    end

    def matches?(msg)
      case trigger
      when String
        trigger == msg.command
      when Regexp
        msg.matches = trigger.match msg.command
      end
    end
  end
end
