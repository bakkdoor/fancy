def class Ping {
  # async method definition
  # gets run, if the message "pong" gets sent asynchronously
  def async pong {
    "Got pong by " ++ __sender__ ++ ", quitting.." println
  }

  def async unknown_message: msg params: p {
    "Unknown message: " ++ msg ++ ", waiting for pong" println
  }
}

def class Pong {
  def initialize: pong_obj {
    pong_obj @ ping # send "ping" message to pong_obj asynchronously
  }

  def async ping {
    "Got PING by " ++ __sender__ ++ ", sending reply!" println
    # async message sends are prefixed with @
    __sender__ @ pong
  }

  def async unknown_message: msg params: p {
    "Unknown message: " ++ msg ++ ", waiting for ping" println
  }
}

# create actor objects
# create Pong
pong = Pong new
# create Ping with pong object
ping = Ping new: pong
