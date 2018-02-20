require "spec"
require "../src/graphite"

class Pub
  getter on_output = Graphite::Event.new(:on_output)
  getter on_bool_changed = Graphite::Event.new(:on_bool_changed)

  def output(msg)
    on_output.fire(StringEventArgs.new(msg))
  end

  def change_bool
    on_bool_changed.fire Graphite::EventArgs.new
  end
end

class StringEventArgs < Graphite::EventArgs
  getter string : String

  def initialize(@string = "")
  end
end

class Sub
  include Graphite::Subscriber
  property string = ""
  property bool = false

  def on_notify(s, e)
    case s
    when :on_output
      change_string e.string if e.is_a? StringEventArgs
    when :on_bool_changed
      change_bool
    else
    end
  end

  def change_string(s : String)
    @string = s
  end

  def change_bool
    @bool = true
  end
end
