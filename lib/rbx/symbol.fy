class Symbol {
  def eval {
    binding = Binding setup(Rubinius VariableScope of_sender(),
                            Rubinius CompiledMethod of_sender(),
                            Rubinius StaticScope of_sender())
    Fancy eval: (self to_s) binding: binding
  }

  def inspect {
    "'" ++ (inspect() from: 1 to: -1)
  }
}
