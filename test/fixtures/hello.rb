require 'tilt/haml'
require 'tilt/erb'
require 'haml'
class Hello < Cognition::Plugins::Base
  match 'hello', :hello, help: {
    'hello' => 'Returns Hello World'
  }

  def hello(msg, match_data = nil)
    'Hello World'
  end

  def hi(msg, match_data = nil)
    @message = 'Hi'
    render
  end

  def hola(msg, match_data = nil)
    @message = 'Hola'
    render(template: File.expand_path('../hello/views/hola.haml', __FILE__))
  end

  def bonjour(msg, match_data = nil)
    @message = 'Bonjour'
    render(type: "text")
  end

  def hey(msg, match_data = nil)
    @message = 'Hey'
    render(extension: "haml")
  end

  def yo(msg, match_data = nil)
    @message = 'Yo'
    render(locals: {num_yos: 3})
  end
end
