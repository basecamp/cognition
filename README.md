# Not Under Active Development
As of 03-2015, Cognition is no longer under active development. If this
changes in the future, I will post it here.  Feel free to use this code as you
see fit in accordance with the LICENSE file!


# Cognition

This is a gem that parses a message, and compares it to various matchers.
When it finds the **first match**, it executes an associated block of code or
method, returning the output of whatever was run.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognition'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cognition

## Usage

Instantiate:
```ruby
bot = Cognition::Bot.new
```

Process your message:
```ruby
result = bot.process('command I need to process')
```

You can also include metadata with your message, like user info, or whatever:
```ruby
result = bot.process('another command', {user_id: 15, name: 'Bob'})
```

Internally, `Cognition` will turn your values into a `Cognition::Message` so
the metadata will be passed along with the message, and arbitrary metadata
is available in the #metadata Hash:
```ruby
msg = Cognition::Message('another command', {user_id: 15, name: 'Bob'})
msg.metadata   # Returns { user_id: 15, name: 'Bob' }
```

### Special metadata
If you include a `callback_url` key in your metadata, we'll give you a
convenience method to reply to it using the `reply` method.  This will
invoke a HTTParty POST back to the URL with your text sent as the
`content` variable.
```ruby
msg = Cognition::Message('another command', {
  callback_url: "http://foo.bar/baz",
  user_id: 15,
  name: 'Bob'
})

msg.reply("foo")   # Posts 'content=foo' to http://foo.bar/baz
```

## Creating a Plugin
Creating plugins is easy. Subclass `Cognition::Plugins::Base` and setup your
matches and logic that should be run:
```ruby
class Hello < Cognition::Plugins::Base
  # Simple string based matcher. Must match *EXACTLY*
  match 'hello', 'hello: Returns Hello World', :hello

  # Advanced Regexp based matcher. Capture groups are made available
  # via MatchData in the matches method
  match /hello\s*(?<name>.*)/, :hello_person, help: {
    'hello <name>' => 'Greets you by name!'
  }


  def hello(*)
    'Hello World'
  end

  def hello_person(msg, match_data = nil)
    name = match_data[:name]
    "Hello #{name}"
  end
end
```

After you've done that, you will be able to do:
```ruby
bot.register(Hello)
bot.process("help hello")  # "hello <name> - Greets you by name!"
bot.process("hello")       # "Hello World"
bot.process("hello foo")   # "Hello foo"
```

### Rendering templates
Templates are opt-in right now, you need to call `render` yourself, and it
will return a string with the rendered contents of a template. What template,
you ask? The default for `/path/to/hello.rb` will look for a templates in
`/path/to/hello/views/`.

Given the following plugin:
```ruby
class Hello < Cognition::Plugins::Base
  # ...snipped

  def hello(*)
    render
  end

  def hi(*)
    render(template: "/path/to/template.html.erb")
  end

  def hey(*)
    render(type: "text", extension: "haml")
  end
end
```

  1. The `hello` method will look for `/path/to/hello/views/hello.html.erb`
  2. The `hi` method will look for `/path/to/template.html.erb`
  3. The `hey` method will look for `/path/to/hello/views/hey.text.haml`

Setting instance variables or passing locals is up to the plugin creator.
The `render` method takes a hash with the following keys:
```ruby
{
  template: "full/path/to/template/file", # FULL path to template file
  type: "type of response"                # text, html, json, etc...
  extension: "engine file extension"      # erb, haml, etc...
  locals: {x: "foo", y: "bar"}            # local variables, access as x & y
}
```

## Contributing

1. Fork it ( https://github.com/anoldguy/cognition/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
