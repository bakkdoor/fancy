# actors example
import: [System]

def actor Ping: pong_receiver {
  pong_receiver ! [:ping, self]
  loop: {
    receive {
      [:pong, pid] -> {
        Console writeln: "Got PONG by #{pid}, quitting.."
        self die
      }
      Any -> {
        Console writeln: "Unknown message: #{message inspect}, waiting for PONG"
      }
    }
  }
}

def actor Pong {
  loop: {
    receive {
      [:ping, pid] -> {
        Console writeln: "Got PING by #{message sender}, sending reply!"
        pid ! :pong
      }
      Any -> {
        Console writeln: "Unknown message: #{message inspect}, waiting for PING"
      }
    }
  }
}

# start actors
def main: args {
  # start Pong
  pong = Pong spawn
  # start Ping with pong's pid
  ping = Ping spawn: [pong]
  # wait for both pong & ping processes
  Process wait: [pong, ping]
}
