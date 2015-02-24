class Hello < Cognition::Plugins::Base
  match 'hello', :hello, help: {
    'hello' => 'Returns Hello World'
  }

  def hello(msg, match_data = nil)
    'Hello World'
  end
end
