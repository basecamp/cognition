class Hello < Cognition::Plugins::Base
  match 'hello', 'hello: Returns Hello World', :hello

  def hello(msg)
    'Hello World'
  end
end
