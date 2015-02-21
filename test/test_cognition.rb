require 'minitest/autorun'
require 'cognition'
require_relative 'fixtures/hello'

class CognitionTest < Minitest::Test
  def setup
    Cognition.reset
  end

  def test_registers_plugins
    Cognition.register(Hello)

    assert_equal 2, Cognition.plugin_names.count
  end

  def test_does_not_register_duplicate_plugins
    Cognition.register(Hello)
    Cognition.register(Hello)

    assert_equal 2, Cognition.plugin_names.count
  end

  def test_processes_messages
    msg = Cognition::Message.new('ping')
    assert_equal 'PONG', Cognition.process(msg)
  end

  def test_processes_strings
    assert_equal 'PONG', Cognition.process('ping')
  end

  def test_processes_strings_with_metadata
    assert_equal 'PONG', Cognition.process('ping', foo: 'bar')
  end

  def test_shows_help_if_no_matches
    Cognition.register(Hello)
    msg = Cognition::Message.new('pong')
    output = Cognition.process(msg)
    assert_match "No such command: pong\nUse 'help' for available commands!", output
  end
end
