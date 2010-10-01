def class AST {
  def class Self : Node {
    def Self from_sexp: sexp {
      Self new
    }

    def to_ruby_sexp: out {
      out print: "[:self]"
    }
  }
}
