require "minitest/autorun"
require "cognition"

class MatcherTest < Minitest::Test
  def test_raises_error_without_a_trigger
    assert_raises ArgumentError do
      _ = Cognition::Matcher.new(action: "foo")
    end
  end

  def test_raises_error_without_an_action
    assert_raises ArgumentError do
      _ = Cognition::Matcher.new(trigger: "foo")
    end
  end

  def test_matches_string
    msg = Cognition::Message.new("help")
    matcher = Cognition::Matcher.new("help", {}, &proc {})
    assert matcher.matches?(msg)
  end

  def test_string_fails_with_invalid_message
    msg = Cognition::Message.new("Help")
    matcher = Cognition::Matcher.new("help", {}, &proc {})
    refute matcher.matches?(msg)
  end

  def test_matches_regexp
    msg = Cognition::Message.new("ping")
    matcher = Cognition::Matcher.new(/ping/, {}, &proc {})
    assert matcher.matches?(msg)
  end

  def test_regexp_fails_with_invalid_message
    msg = Cognition::Message.new("pink")
    matcher = Cognition::Matcher.new(/ping/, {}, &proc {})
    refute matcher.matches?(msg)
  end

  def test_sets_response_on_attemp_if_matches
    msg = Cognition::Message.new("ping")
    matcher = Cognition::Matcher.new(/ping/, {}, &proc { "PONG" })
    matcher.attempt(msg)
    assert_equal "PONG", matcher.response
  end

  def test_returns_false_on_attemp_if_no_match
    msg = Cognition::Message.new("pink")
    matcher = Cognition::Matcher.new(/ping/, {}, &proc { "PONG" })
    refute matcher.attempt(msg)
  end

  def test_sets_match_data
    msg = Cognition::Message.new("hello john")
    matcher = Cognition::Matcher.new(/hello\s*(?<name>.*)/, {}, &proc { "PONG" })
    matcher.matches?(msg)
    assert_equal "john", matcher.match_data[:name]
  end

  def test_captures_response
    msg = Cognition::Message.new("hello john")
    matcher = Cognition::Matcher.new(/hello\s*(?<name>.*)/, {}, &proc(&method(:dummy_method)))
    matcher.attempt(msg)
    assert_equal "Hello john", matcher.response
  end

  def test_only_sets_help_when_help_provided
    matcher_without_help = Cognition::Matcher.new(/hello\s*(?<name>.*)/, {}, &proc(&method(:dummy_method)))
    assert_equal [], matcher_without_help.help
  end

  def test_sets_help
    matcher_with_help = Cognition::Matcher.new(/hello\s*(?<name>.*)/, { help: { "hello" => "says hello" } }, &proc(&method(:dummy_method)))
    assert_equal ["hello - says hello"], matcher_with_help.help
  end

  def test_raises_exception_when_command_fails
    msg = Cognition::Message.new("boom")
    matcher = Cognition::Matcher.new(/boom/, {}, &proc(&method(:blow_up)))
    matcher.attempt(msg)
    assert matcher.response.include? "ZeroDivisionError"
  end
end

def dummy_method(_, match_data)
  "Hello #{match_data['name']}"
end

def blow_up(msg, match_data)
  raise ZeroDivisionError, "divided by 0"
end