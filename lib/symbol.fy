class Symbol {
  def call: arg {
    """
    This allows Symbols to be used like Blocks
    (e.g. in all methods of Enumerable).
    Example: [1, 2, 3] map: 'squared # => [1, 4, 9]
    """

    arg is_a?: Array . if_true: {
      arg first send: self params: $ arg rest
    } else: {
      arg send: self
    }
  }

  def eval {
    "Evaluates the symbol within the current scope."

    self to_s eval
  }
}
