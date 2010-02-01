# actors example

class Ping < Actor {
  def start: receiver {
    receiver !: :ping
  }
  
  def receive: message {
    case_of message {
      :pong -> {
        Console writeln: "Got PONG by #{message sender}, quitting.."
        self die
      }
      Any -> {
        Console writeln: "Unknown message: #{message inspect}, waiting for PONG"
        self receive
      }
    }
  }
}

class Pong < Actor {
  def receive: message {
    case_of message {
      :ping -> {
        Console writeln: "Got PING by #{message sender}, sending reply!"
        message sender !: :pong
      }
      Any -> {
        Console writeln: "Unknown message: #{message inspect}, waiting for PING"
        self receive
      }
    }
  }
}
  
