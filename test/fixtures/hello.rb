require "tilt/haml"
require "tilt/erb"
require "haml"
class Hello < Cognition::Plugins::Base
  match "hello", :hello, help: {
    "hello" => "Returns Hello World"
  }

  def hello(*)
    "Hello World"
  end

  def hi(*)
    @message = "Hi"
    render
  end

  def hola(*)
    @message = "Hola"
    render(template: File.expand_path("../hello/views/hola.haml", __FILE__))
  end

  def bonjour(*)
    @message = "Bonjour"
    render(type: "text")
  end

  def hey(*)
    @message = "Hey"
    render(extension: "haml")
  end

  def yo(*)
    @message = "Yo"
    render(locals: { num_yos: 3 })
  end
end
