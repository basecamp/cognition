class Hello < Cognition::Plugins::Base
  match 'hello', 'hello: Returns Hello World', :hello

  def hello(*)
    'Hello World'
  end
end
