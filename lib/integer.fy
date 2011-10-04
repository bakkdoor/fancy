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
}