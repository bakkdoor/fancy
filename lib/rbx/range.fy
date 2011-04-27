class Range {
  ruby_alias: 'to_a
  ruby_alias: '==
  ruby_alias: '===

  include: FancyEnumerable

  def initialize: start to: end {
    initialize(start, end)
  }

  def each: block {
    try {
      val = nil
      each() |x| {
        try {
          val = block call: [x]
        } catch (Fancy NextIteration) => ex {
          val = ex return_value
        }
      }
      val
    } catch (Fancy BreakIteration) => ex {
      ex return_value
    }
  }
}
