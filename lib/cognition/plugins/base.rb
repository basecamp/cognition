module Cognition
  module Plugins
    class Base
      attr_accessor :matchers

      def initialize
        @matchers = self.class.definitions.collect do |trigger, method_name, options|
          Matcher.new(trigger, options, &Proc.new(&method(method_name)))
        end
      end

      def self.match(trigger, action, options = {})
        definitions << [trigger, action, options]
      end

      def self.definitions
        @definitions ||= []
      end
    end
  end
end
