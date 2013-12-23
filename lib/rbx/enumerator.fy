class Enumerable Enumerator {
  forwards_unary_ruby_methods
  alias_method: 'to_a for_ruby: 'to_a

  def each: block {
    each(&block)
  }
}
