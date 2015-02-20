require 'minitest/autorun'
require 'cognition'
require_relative 'fixtures/hello'

class CognitionTest < Minitest::Test
  def setup
    Cognition.reset
  end

  def test_registers_plugins
    Cognition.register(Hello)

    assert_equal 2, Cognition.plugins.count
    assert_instance_of Hello, Cognition.plugins.last
  end

  def test_processes_messages
    msg = Cognition::Message.new('ping')
    assert_equal 'PONG', Cognition.process_message(msg)
  end

  def test_shows_help_if_no_matches
    Cognition.register(Hello)
    msg = Cognition::Message.new('pong')
    output = Cognition.process_message(msg)
    assert_match 'No such command:', output
    assert_match 'ping: Returns "PONG"', output
    assert_match 'hello: Returns Hello World', output
  end
end
