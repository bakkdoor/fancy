def class AST {
  def class Super : Node {
    def Super from_sexp: sexp {
      Super new
    }

    def to_ruby: out indent: ilvl {
      out print: "super"
    }
  }
}
