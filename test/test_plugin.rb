require 'minitest/autorun'
require 'cognition'

class PluginTest < Minitest::Test
  def test_sets_matchers
    require_relative "fixtures/hello"
    hello = Hello.new

    assert_equal 1, hello.matchers.count
  end
end
