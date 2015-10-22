require "minitest/autorun"
require "cognition"

class DefaultPluginTest < Minitest::Test
  def setup
    @bot = Cognition::Bot.new
  end

  def test_returns_help
    help = "ping - Test if the endpoint is responding. Returns PONG.\nhelp - Lists all commands with help\nhelp <command> - Lists help for <command>"
    assert_equal help, @bot.process("help")
  end

  def test_returns_filtered_help
    help = "ping - Test if the endpoint is responding. Returns PONG."
    assert_equal help, @bot.process("help ping")
  end
end
