require "erb"
require "tilt"
require "cgi"

module Cognition
  module Plugins
    class PluginTemplateNotFound < StandardError; end

    class Base
      class <<self
        attr_accessor :view_root
      end

      RENDER_DEFAULTS = {
        type: "html",
        extension: "erb"
      }

      # Inherited callback to set a class-level instance variable on the
      # subclass, since we can't use __FILE__ here, and have it use the
      # subclass's location.
      def self.inherited(plugin)
        plugin.view_root = File.dirname(caller[0].split(":", 2).first)
      end

      attr_accessor :matchers, :bot

      def initialize(bot = nil)
        @matchers = self.class.definitions.collect do |trigger, method_name, options|
          Matcher.new(trigger, options) do |msg, match_data|
            @msg = msg
            method(method_name).call(msg, match_data)
          end
        end
        @bot = bot
      end

      def self.match(trigger, action, options = {})
        definitions << [trigger, action, options]
      end

      def self.definitions
        @definitions ||= []
      end

      def render(opts = {})
        options = RENDER_DEFAULTS.merge(opts)
        # ruby <= 3.3.6: test.rb:9:in `c'
        # ruby >= 3.4.1: test.rb:9:in 'A#c'
        calling_method = caller[0][/[`'](?:.*#)?([^']*)'/, 1]
        template = options[:template] || template_file(calling_method, options[:type], options[:extension])
        filter Tilt.new(template).render(self, options[:locals])
      rescue Errno::ENOENT => e
        raise PluginTemplateNotFound, e
      end

      private
        def template_file(name, type, extension)
          # Defaults to html ERB for now. Override when calling #render(path_to_file)
          File.join(templates_path, "#{name}.#{type}.#{extension}")
        end

        def templates_path
          File.expand_path("#{underscore(self.class.name)}/views", self.class.view_root)
        end

        def underscore(string)
          word = string.to_s.gsub(/::/, "/")
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, "\\1_\\2")
          word.gsub!(/([a-z\d])([A-Z])/, "\\1_\\2")
          word.tr!("-", "_")
          word.downcase!
          word
        end

        def filter(full_response)
          filter = @msg&.filter
          return full_response unless filter

          filter = filter.sub(/^grep\s*/, "")

          full_response.each_line.select do |line|
            line.downcase.include?(filter.downcase) ||
              line.downcase.include?("ul>") # Don't strip wrapping ul tags
          end.join
        end
    end
  end
end
