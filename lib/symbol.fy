class Symbol {
  """
  Symbols are unique identifiers and only created once.

  If there are several occurrances of the same Symbol literal within
  Fancy code, they all refer to the same Symbol object.
  """

  def call: arg {
    """
    @arg Argument to send @self to.
    @return Value of sending @self as message to @arg.

    This allows Symbols to be used like Blocks (e.g. in all methods of Enumerable).

    Example:
          [1, 2, 3] map: 'squared # => [1, 4, 9]
    """

    if: (arg is_a?: Array) then: {
      arg first receive_message: self with_params: $ arg rest
    } else: {
      arg receive_message: self
    }
  }

  def call {
    """
    Sends @self as message to the sender in its context.

    Example:
          'foo call
           # => same as
           self foo

           if: x then: 'foo else: 'bar
           # same as:
           if: x then: { self foo } else: { self bar }
    """

    binding = Binding setup(Rubinius VariableScope of_sender(),
                            Rubinius CompiledMethod of_sender(),
                            Rubinius StaticScope of_sender())
    recv = binding self()
    recv receive_message: self
  }

  def call_with_receiver: receiver {
    call: [receiver]
  }

  def call: args with_receiver: receiver {
    call: $ args unshift: receiver
  }

  def arity {
    1
  }

  def to_sym {
    self
  }

  def to_block {
    """
    @return @Block@ that sends @self to its first argument, passing along any remaining arguments.

    Example:
          'inspect to_block
          # is equal to:
          @{ inspect }
    """

    |args| {
      call: args
    }
  }
}
