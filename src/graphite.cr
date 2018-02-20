require "./graphite/*"

module Graphite
  class Event
    getter subs = Set(Subscriber).new

    def initialize(@signature : Symbol)
    end

    def add(subscriber : Subscriber)
      subs << subscriber
    end

    def <<(subscriber : Subscriber)
      subs << subscriber
    end

    def remove(subscriber : Subscriber)
      subs.delete subscriber
    end

    def remove_all
      subs.clear
    end

    def fire(event_args : EventArgs)
      subs.each do |s|
        s.on_notify @signature, event_args
      end
    end
  end

  class EventArgs
  end

  module Subscriber
    abstract def on_notify(event : Symbol, args : EventArgs)
  end
end
