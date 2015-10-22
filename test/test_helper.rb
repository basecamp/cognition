require "webmock/minitest"

module Minitest
  class Test
    include WebMock::API
  end
end
