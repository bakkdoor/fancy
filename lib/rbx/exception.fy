class Exception {
  """
  Base Exception class.
  All Exception classes inherit from @Exception@.
  """

  forwards_unary_ruby_methods
}

class StandardError {
  """
  StandardError. Base class of most Exception classes.
  """

  forwards_unary_ruby_methods

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
