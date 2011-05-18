class Range {
  ruby_alias: 'to_a
  ruby_alias: '==
  ruby_alias: '===
  ruby_alias: 'first
  ruby_alias: 'last

  def initialize: @start to: @end {
    """
    @start Start element of Range.
    @end End element of Range.

    Initializes a new Range starting at @start and ending at @end.
    """

    initialize(@start, @end)
  }

  def each: block {
    """
    @block @Block@ to be called with every value in @self.
    @return @self.

    Calls @block on each value in @self. Used for iterating over a @Range@.
    """

    try {
      val = nil
      each() |x| {
        try {
          val = block call: [x]
        } catch (Fancy NextIteration) => ex {
          val = ex result
        }
      }
      return self
    } catch (Fancy BreakIteration) => ex {
      ex result
    }
  }
}
