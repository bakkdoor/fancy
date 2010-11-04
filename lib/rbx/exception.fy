class StandardError {
  ruby_alias: 'message

  def initialize {
    "Creates a new Exception with an empty message."

    initialize()
  }

  def initialize: msg {
    """
    @msg Message (@String@) for the Exception.

    Creates a new Exception with a given message.
    """

    self initialize(msg)
  }

  def raise! {
    """
    Raises (throws) an Exception to be caught somewhere up the
    callstack.
    """

    raise(self)
  }
}

StdError = StandardError
