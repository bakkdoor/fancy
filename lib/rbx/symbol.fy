class Symbol {
  def eval {
    binding = Binding setup(Rubinius VariableScope of_sender(),
                            Rubinius CompiledMethod of_sender(),
                            Rubinius StaticScope of_sender())
    Fancy eval: to_s binding: binding
  }

  def inspect {
    "'" ++ to_s
  }

  def defined? {
    """
    @return @true, if @self is defined as a constant in senders scope, @false otherwise.

    Indicates if a Symbol is defined as a constant in the senders scope.
    """

    binding = Binding setup(Rubinius VariableScope of_sender(),
                            Rubinius CompiledMethod of_sender(),
                            Rubinius StaticScope of_sender())

    binding self() class const_defined?(self)
  }

  def message_name {
    symbol = self to_s
    val = symbol include?(":")
    match val {
      case true -> symbol to_sym
      case false -> ":" <<(symbol) to_sym
    }
  }

  def to_fancy_message {
    to_s to_fancy_message to_sym
  }

  def =~ regexp {
    to_s =~ regexp
  }
}
