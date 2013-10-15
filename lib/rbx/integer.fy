class Integer {
  # common ruby-forwarding methods used by Fixnum & Bignum classes

  def times: block {
    """
    @block @Block@ to be called with each number between 0 and @self.
    @return @self.

    Calls a given @Block@ with each number between 0 and @self.
    """

    try {
      times(&block)
    } catch Fancy BreakIteration => b {
      return b result
    } catch Fancy StopIteration => s {
      return s result
    }
  }
}
