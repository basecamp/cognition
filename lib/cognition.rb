require 'cognition/version'
require 'cognition/message'
require 'cognition/matcher'
require 'cognition/plugins/base'
require 'cognition/plugins/ping'

module Cognition
  extend self

  attr_accessor :plugins, :matchers

  def process(msg, metadata = {})
    if msg.is_a? Cognition::Message
      process_msg(msg)
    else
      process_string(msg.to_s, metadata)
    end
  end

  def process_msg(msg)
    response = false
    matchers.each do |matcher|
      if matcher.attempt(msg)
        response = matcher.response
        break
      end
    end
    response ? response : help
  end

  def process_string(message, metadata = {})
    process_msg(Cognition::Message.new(message, metadata))
  end

  def register(klass)
    return false if plugin_names.include? klass.to_s
    plugins << klass.new
  end

  def reset
    @matchers = []
    @plugins = []
    register(Cognition::Plugins::Ping)
  end

  def help
    "No such command:\n\n #{matchers.map(&:help).join('\n')}"
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
