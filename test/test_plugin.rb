require 'minitest/autorun'
require 'cognition'

class PluginTest < Minitest::Test
  def setup

  end

  def test_sets_matchers
    require_relative "fixtures/hello"
    bot = Cognition::Bot.new
    hello = Hello.new(bot)

    assert_equal 1, hello.matchers.count
  end

  def test_renders_default_template
    require_relative "fixtures/hello"
    hello = Hello.new

    assert_equal "Hi from a default template!\n", hello.hi("foo")
  end

  def test_renders_passed_template
    require_relative "fixtures/hello"
    hello = Hello.new

    assert_equal "<h1>Hola</h1>\n", hello.hola("foo")
  end

  def test_renders_specified_type
    require_relative "fixtures/hello"
    hello = Hello.new

    assert_equal "Bonjour is french!\n", hello.bonjour("foo")
  end

  def test_renders_specified_engine
    require_relative "fixtures/hello"
    hello = Hello.new

    assert_equal "<h1>Hey</h1>\n", hello.hey("foo")
  end

  def test_renders_with_locals
    require_relative "fixtures/hello"
    hello = Hello.new

    assert_equal "<p>Yo</p>\n<p>Yo</p>\n<p>Yo</p>\n", hello.yo("foo")
  end
end
