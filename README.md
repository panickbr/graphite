# graphite

Lightweight event library based on C# Events.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  graphite:
    github: panickbr/graphite
```

## Usage

```crystal
require "graphite"
```

* Define a Custom EventArgs

``` crystal
class MyEventArgs < Graphite::EventArgs
  getter string : String
  
  def initialize(@string = "")
  end
end
```
* Define a Publisher

``` crystal
class Publisher
  getter on_event = Graphite::Event.new(:on_event)

  def event(string)
    on_event.fire MyEventArgs.new(string)
  end
end
```

`:on_event` is the `Event`'s signature. It's what a `Subscriber` will check to react to an `Event` accordingly

* Define a Subscriber

``` crystal
class Subscriber
  include Graphite::Subscriber # Required

  def on_notify(e : Symbol, args : EventArgs) # Required
    case e
    when :on_event
      # You have to check args type to access its methods/variables
      if args.is_a? MyEventArgs
        call_some_method(args.string) 
      end
    end
  end
end
```

* Subscribe to an Event

``` crystal
 pub = Publisher.new
 sub = Subscriber.new
 
 pub.on_event << sub
```

When inside the Subscriber, pass `itself` to subscribe:

``` crystal
class Subscriber
# ...
  pub.on_event << itself
# ...
end
```

Done. Now every time `Publisher#event` or `Publisher#on_event.fire` is called, all `on_event` subscribers will be notified and react according to its own `#on_notify` method.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/graphite/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [panickbr](https://github.com/panickbr) panickbr - creator, maintainer
