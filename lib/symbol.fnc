def class Symbol {
  def call: arg {
    ""This allows Symbols to be used like Blocks (e.g. in all methods of Enumerable).
      Example: [1, 2, 3] map: :squared # => [1, 4, 9]"";

    arg is_a?: Array . if_true: {
      arg each: |a| { a send: self }
    } else: {
      arg send: self
    }
  }
}
