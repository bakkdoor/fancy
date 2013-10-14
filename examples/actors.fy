# Does the same as actors_primitive.fy but using
# normal objects as actors by sending messages asynchronously (via @@ syntax).
class PingPong {
  def initialize: @block

  def count: count reply: other notify: parent {
    @block call
    if: (count > 1000) then: {
      count println
      parent run
    } else: {
      other @@ count: (count + 1) reply: self notify: parent
    }
  }
}

pong = PingPong new: { "-" print }
ping = PingPong new: { "." print }

ping @@ count: 1 reply: pong notify: $ Thread current
Thread stop