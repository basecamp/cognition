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

Process your message:
```ruby
result = Cognition.process('command I need to process')
```

You can also include metadata with your message, like user info, or whatever:
```ruby
result = Cognition.process('another command', {user_id: 15, name: 'Bob'})
```

Internally, `Cognition` will turn your values into a `Cognition::Message` so
the metadata will be passed along with the message, and arbitrary metadata
is available in the #metadata Hash:
```ruby
msg = Cognition::Message('another command', {user_id: 15, name: 'Bob'})
msg.metadata   # Returns { user_id: 15, name: 'Bob' }
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
  match /hello\s*(?<name>.*)/, 'hello <name>', :hello_person


  def hello(*)
    'Hello World'
  end

  def hello_person(msg)
    name = msg.matches[:name]
    "Hello #{name}"
  end
end
```

## Contributing

1. Fork it ( https://github.com/anoldguy/cognition/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
