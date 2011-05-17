# Does the same as actors_primitive.fy but using
# normal objects as actors by sending messages asynchronously (via @@ syntax).
class PingPong {
  Done = false
  def initialize: @block {
  }

  def count: count reply: other {
    @block call
    if: (count > 1000) then: {
      count println
      Done = true
    } else: {
      other @@ count: (count + 1) reply: self
    }
  }
}

pong = PingPong new: { "-" print }
ping = PingPong new: { "." print }

ping @@ count: 1 reply: pong

until: { PingPong Done } do: {
  Thread sleep: 0.1
}