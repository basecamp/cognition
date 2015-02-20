require 'cognition/version'
require 'cognition/message'
require 'cognition/matcher'
require 'cognition/plugins/base'
require 'cognition/plugins/ping'

module Cognition
  extend self

  attr_accessor :plugins, :matchers

  def register(klass)
    return false if plugin_names.include? klass.to_s

    plugins << klass.new
  end

  def process_message(msg)
    response = false
    matchers.each do |matcher|
      if matcher.attempt(msg)
        response = matcher.response
        break
      end
    end
    response ? response : help
  end

  def help
    "No such command:\n\n #{matchers.map(&:help).join("\n")}"
  end

  def matchers
    plugins.collect(&:matchers).flatten.compact
  end

  def plugin_names
    plugins.map { |p| p.class.name }
  end

  def plugins
    @plugins ||= []
  end
end

# Default plugin, responds to 'ping' with 'PONG'
Cognition.register(Cognition::Plugins::Ping)
