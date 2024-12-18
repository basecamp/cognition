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
      full_response = action.call(msg, match_data).to_s
      @response = filter(full_response, msg.filter)
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

    private
      def filter(full_response, filter)
        return full_response unless filter

        filter = filter.sub(/^grep\s*/, "")

        full_response.each_line.select { |line| line.include? filter }.join
      end
  end
end
