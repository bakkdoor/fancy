def class StdError : StandardError {
  def initialize: msg {
    self initialize: ~[msg]
  }

  def raise! {
    raise: ~[self]
  }
}
