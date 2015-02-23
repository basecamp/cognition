require 'minitest/autorun'
require 'cognition'
require 'test_helper'

class ResponderTest < Minitest::Test
  def test_sends_reply
    stub_request(:any, "http://foo.bar/path").
      to_return(status: 200)
    responder = Cognition::Responder.new('http://foo.bar/path')

    assert_equal 200, responder.reply('foobar').code
  end

  def test_handles_timeouts
    stub_request(:any, "http://foo.bar/path").to_timeout
    responder = Cognition::Responder.new('http://foo.bar/path')

    assert_equal 'Request to http://foo.bar/path timed out.', responder.reply('foobar')
  end
end
