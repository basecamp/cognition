require 'minitest/autorun'
require 'cognition'

class PluginTest < Minitest::Test
  def setup
    require_relative "fixtures/hello"
    bot = Cognition::Bot.new
    @hello = Hello.new(bot)
  end

  def test_sets_matchers
    assert_equal 1, @hello.matchers.count
  end

  def test_renders_default_template
    assert_equal "Hi from a default template!\n", @hello.hi("foo")
  end

  def test_renders_passed_template
    assert_equal "<h1>Hola</h1>\n", @hello.hola("foo")
  end

  def test_renders_specified_type
    assert_equal "Bonjour is french!\n", @hello.bonjour("foo")
  end

  def test_renders_specified_engine
    assert_equal "<h1>Hey</h1>\n", @hello.hey("foo")
  end

  def test_renders_with_locals
    assert_equal "<p>Yo</p>\n<p>Yo</p>\n<p>Yo</p>\n", @hello.yo("foo")
  end

  def test_multiple_render_calls
    assert_equal "<p>Yo</p>\n<p>Yo</p>\n<p>Yo</p>\n", @hello.yo("foo")
    assert_equal "<h1>Hey</h1>\n", @hello.hey("foo")
  end
end
