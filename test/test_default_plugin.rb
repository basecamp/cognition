require 'minitest/autorun'
require 'cognition'

class DefaultPluginTest < Minitest::Test
  def setup
    Cognition.reset
  end

  def test_returns_help
    help = "ping - Test if the endpoint is responding. Returns PONG.\\nhelp - Lists all commands with help\\nhelp <command> - Lists help for <command>"
    assert_equal help, Cognition.process("help")
  end

  def test_returns_filtered_help
    help = "ping - Test if the endpoint is responding. Returns PONG."
    assert_equal help, Cognition.process("help ping")
  end
end
