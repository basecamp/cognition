require "minitest/autorun"
require "cognition"

class CognitionTest < Minitest::Test
  def test_sets_metadata
    msg = Cognition::Message.new("test", user_id: 15, foo: "bar")
    assert_equal 15, msg.metadata[:user_id]
    assert_equal "bar", msg.metadata[:foo]
  end

  def test_sets_responder_if_callback_url
    msg = Cognition::Message.new("ping", "callback_url" => "http://foo.bar/")
    assert_kind_of Cognition::Responder, msg.responder
  end

  def test_no_responder_if_no_callback_url
    msg = Cognition::Message.new("ping", user: { name: "foo", id: 123_456 })
    refute msg.responder
  end

  def test_splits_command_and_filter_on_pipe
    msg = Cognition::Message.new("alerts | grep CPU")
    assert_equal "alerts", msg.command
    assert_equal "grep CPU", msg.filter
  end

  def test_preserves_pipe_inside_double_quotes
    msg = Cognition::Message.new('silence env=~"^(prod|staging)$" 30')
    assert_equal 'silence env=~"^(prod|staging)$" 30', msg.command
    assert_nil msg.filter
  end

  def test_preserves_literal_pipe_in_quoted_value
    msg = Cognition::Message.new('silence resource="foo|bar"')
    assert_equal 'silence resource="foo|bar"', msg.command
    assert_nil msg.filter
  end

  def test_splits_on_pipe_after_quoted_string
    msg = Cognition::Message.new('silence env=~"^(prod|staging)$" | grep foo')
    assert_equal 'silence env=~"^(prod|staging)$"', msg.command
    assert_equal "grep foo", msg.filter
  end

  def test_command_without_pipe
    msg = Cognition::Message.new("ping")
    assert_equal "ping", msg.command
    assert_nil msg.filter
  end

  def test_multiple_pipes_outside_quotes
    msg = Cognition::Message.new("alerts | grep CPU | head")
    assert_equal "alerts", msg.command
    assert_equal "grep CPU | head", msg.filter
  end
end
