require 'webmock/minitest'

class Minitest::Test
  include WebMock::API
end
