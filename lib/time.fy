class Time {
  def Time duration: block {
    """
    @block @Block to be called & timed.
    @return @Float@ that is the duration (in seconds) of calling @block.

    Calls @block and times the runtime duration of doing so in seconds.

    Example:
          Time duration: { Thread sleep: 1 } # => >= 1.0
    """

    start = Time now
    block call
    Time now - start
  }
}