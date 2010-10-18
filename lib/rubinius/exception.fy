def class StdError : StandardError {
  ruby_alias: 'message

  def initialize: msg {
    self initialize: ~[msg]
  }

  def raise! {
    raise: ~[self]
  }
}
