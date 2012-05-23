class Integer {
  """
  Base class for integer values in Fancy.
  """

  def times: block offset: offset {
    """
    @block @Block@ to be called with each number between @offset and @self.
    @offset Offset to be used as starting point of iteration.
    @return @self.

    Similar to #times: but starts at a given offset.
    """

    times: |i| {
      block call: [i + offset]
    }
  }

  def times_try: block retry_with: retry_block ({}) {
    """
    @block @Block@ to be called and retries @self amount of times if exceptions get thrown.
    @retry_block @Block@ to be called before retrying execution of @block. Defaults to an empty @Block@.
    @return Return value of calling @block or raises an exception after @self tries.
            Returns @nil if @self <= 0.

    Tries to call a @Block@ @self amount of times, returning its return
    value or raising the last exception raised frin @block after @self tries.

    Example:
          2 times_try: {
            # this code will be tried 2 times.
            # if it succeeds the first time, simply return its value, otherwise try once more.
            # if it still fails after 2 attempts, raises the exception thrown (in this case probably an IOError).
            @connection readln
          } retry_with: { @connection reconnect }
    """

    max_retries = self
    { return nil } if: $ max_retries <= 0
    value = nil
    try {
      value = block call: [max_retries]
    } catch StandardError => e {
      max_retries = max_retries - 1
      { e raise! } unless: $ max_retries > 0
      retry_block call
      retry
    } finally {
      return value
    }
  }
}