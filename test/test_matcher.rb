require 'minitest/autorun'
require 'cognition'

class MatcherTest < Minitest::Test
  def test_raises_error_without_a_trigger
    assert_raises ArgumentError do
      _ = Cognition::Matcher.new(action: 'foo')
    end
  end

  def test_raises_error_without_an_action
    assert_raises ArgumentError do
      _ = Cognition::Matcher.new(trigger: 'foo')
    end
  end

  def test_matches_string
    msg = Cognition::Message.new('help')
    matcher = Cognition::Matcher.new('help', 'test', &Proc.new {})
    assert matcher.matches?(msg)
  end

  def test_string_fails_with_invalid_message
    msg = Cognition::Message.new('Help')
    matcher = Cognition::Matcher.new('help', 'test', &Proc.new {})
    refute matcher.matches?(msg)
  end

  def test_matches_regexp
    msg = Cognition::Message.new('ping')
    matcher = Cognition::Matcher.new(/ping/, 'test', &Proc.new {})
    assert matcher.matches?(msg)
  end

  def test_regexp_fails_with_invalid_message
    msg = Cognition::Message.new('pink')
    matcher = Cognition::Matcher.new(/ping/, 'test', &Proc.new {})
    refute matcher.matches?(msg)
  end

  def test_sets_response_on_attemp_if_matches
    msg = Cognition::Message.new('ping')
    matcher = Cognition::Matcher.new(/ping/, 'test', &Proc.new {'PONG'})
    matcher.attempt(msg)
    assert_equal 'PONG', matcher.response
  end

  def test_returns_false_on_attemp_if_no_match
    msg = Cognition::Message.new('pink')
    matcher = Cognition::Matcher.new(/ping/, 'test', &Proc.new {'PONG'})
    refute matcher.attempt(msg)
  end

  def test_sets_match_data
    msg = Cognition::Message.new('hello john')
    matcher = Cognition::Matcher.new(/hello\s*(?<name>.*)/, 'test', &Proc.new {'PONG'})
    matcher.matches?(msg)
    assert_equal "john", matcher.match_data[:name]
  end

  def test_captures_response
    msg = Cognition::Message.new('hello john')
    matcher = Cognition::Matcher.new(/hello\s*(?<name>.*)/, 'test', &Proc.new(&method(:dummy_method)))
    matcher.attempt(msg)
    assert_equal "Hello john", matcher.response
  end
end

def dummy_method(msg, match_data)
  "Hello #{match_data['name']}"
end
