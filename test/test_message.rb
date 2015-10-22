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
end
