def class StandardError {
  ruby_alias: 'message

  def initialize {
    initialize: ~[]
  }

  def initialize: msg {
    self initialize: ~[msg]
  }

  def raise! {
    raise: ~[self]
  }
}

StdError = StandardError
