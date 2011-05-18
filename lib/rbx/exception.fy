class StandardError {
  """
  StandardError. Base class of most Exception classes.
  """

  ruby_alias: 'message
  ruby_alias: 'backtrace

  def initialize {
    "Creates a new Exception with an empty message."

    initialize()
  }

  def initialize: msg {
    """
    @msg Message (@String@) for the Exception.

    Creates a new Exception with a given message.
    """

    initialize(msg)
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
