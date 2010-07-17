def class Symbol {
  def call: arg {
    """This allows Symbols to be used like Blocks (e.g. in all methods of Enumerable).
       Example: [1, 2, 3] map: :squared # => [1, 4, 9]""";

    arg is_a?: Array . if_true: {
      arg first send: self params: (arg[[1,-1]])
    } else: {
      arg send: self
    }
  }
}
