require "minitest/autorun"
require "cognition"
require_relative "fixtures/hello"
require_relative "fixtures/anchor"

class CognitionTest < Minitest::Test
  def setup
    @bot = Cognition::Bot.new
  end

  def test_registers_plugins
    @bot.register(Hello)

    assert_equal 2, @bot.plugin_names.count
  end

  def test_does_not_register_duplicate_plugins
    @bot.register(Hello)
    @bot.register(Hello)

    assert_equal 2, @bot.plugin_names.count
  end

  def test_processes_messages
    msg = Cognition::Message.new("ping")
    assert_equal "PONG", @bot.process(msg)
  end

  def test_processes_strings
    assert_equal "PONG", @bot.process("ping")
  end

  def test_processes_strings_with_metadata
    assert_equal "PONG", @bot.process("ping", foo: "bar")
  end

  def test_shows_help_if_no_matches
    @bot.register(Hello)
    msg = Cognition::Message.new("pong")
    output = @bot.process(msg)
    assert_match "No such command: pong\nUse 'help' for available commands!", output
  end

  def test_anchored_ping
    @bot.register(Anchor)

    assert_equal 'OK', @bot.process("ping me")
  end
end
