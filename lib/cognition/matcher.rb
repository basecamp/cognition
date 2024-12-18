module Cognition
  class Matcher
    attr_reader :trigger, :action, :response, :help, :match_data

    def initialize(trigger, options = {}, &action)
      fail ArgumentError, "matcher must have a trigger" unless trigger
      fail ArgumentError, "matcher must have an action" unless action
      @trigger = trigger
      @help = options[:help] ||= {}
      @action = action
    end

    def help
      @help.map do |command, description|
        "#{command} - #{description}"
      end
    end

    def attempt(msg)
      return false unless matches?(msg)
      run(msg)
    end

    def run(msg)
      @response = action.call(msg, match_data).to_s
    rescue => e
      @response = "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
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
