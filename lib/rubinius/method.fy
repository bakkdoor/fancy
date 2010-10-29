class Rubinius CompiledMethod {
  def documentation {
    @documentation
  }

  def documentation: str {
    @documentation = str
  }
}


class Method {

  def documentation {
    self executable() documentation
  }

  def documentation: str {
    self executable() documentation: str
  }

}

class UnboundMethod {

  def documentation {
    self executable() documentation
  }

  def documentation: str {
    self executable() documentation: str
  }

}
