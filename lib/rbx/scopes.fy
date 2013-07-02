class Rubinius VariableScope {
  forwards_unary_ruby_methods

  def receiver {
    @self
  }

  def receiver: recv {
    @self = recv
  }
}

class Rubinius ConstantScope {
  forwards_unary_ruby_methods
}
