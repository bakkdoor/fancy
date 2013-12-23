class StandardError {
  def self raise: message {
    """
    Raises new @Exception@ with @message.

    Example:

          StandardError raise: \"Error!\"
          ArgumentError raise: \"Missing argument!\"
          # is the same as:
          StandardError new: \"Error!\” . raise!
          ArgumentError new: \"Missing argument!\" . raise!
    """

    new: message . raise!
  }
}
