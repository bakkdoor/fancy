class Range {
  ruby_alias: 'to_a
  ruby_alias: '==
  ruby_alias: '===

  include: FancyEnumerable

  def initialize: start to: end {
    initialize(start, end)
  }

  def each: block {
    each(&block)
  }
}
