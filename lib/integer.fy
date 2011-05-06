class Integer {
  def times: block {
    """
    @block @Block@ to be called with each number between 0 and @self.
    @return @self

    Calls a given @Block@ with each number between 0 and @self.
    """

    tmp = 0
    while: { tmp < self } do: {
      block call: [tmp]
      tmp = tmp + 1
    }
    self
  }

  def times: block offset: offset {
    """
    @block @Block@ to be called with each number between @offset and @self.
    @offset Offset to be used as starting point of iteration.
    @return @self.

    Similar to #times: but starts at a given offset.
    """

    self times: |i| {
      block call: [i + offset]
    }
  }
}