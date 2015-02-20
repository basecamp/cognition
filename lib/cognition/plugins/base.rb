module Cognition
  module Plugins
    class Base
      attr_accessor :matchers

      def initialize
        @matchers = self.class.definitions.collect do |trigger, help, method_name|
          Matcher.new(trigger, help, &Proc.new(&method(method_name)))
        end
      end

      def self.match(trigger, help, action)
        definitions << [trigger, help, action]
      end

      def self.definitions
        @definitions ||= []
      end
    end
  end
end
