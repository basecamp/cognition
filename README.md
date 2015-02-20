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
the metadata will be passed along with the message, and the keys will be made
into methods that return the value. The raw metadata is also made available:
```ruby
msg = Cognition::Message('another command', {user_id: 15, name: 'Bob'})
msg.user_id    # Returns 15
msg.name       # Returns 'Bob'
msg.metadata   # Returns { user_id: 15, name: 'Bob' }
```

## Contributing

1. Fork it ( https://github.com/anoldguy/cognition/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
