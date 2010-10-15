StdError = StandardError

def class Exception {
  def initialize: message {
    self initialize: ~[message]
  }

  def raise! {
    raise: ~[self]
  }
}
