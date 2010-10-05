def class AST {
  def class Return : Node {
    read_slots: ['expr]
    def initialize: expr {
      @expr = expr
    }

    def Return from_sexp: sexp {
      Return new: $ sexp second to_ast
    }

    def to_ruby_sexp: out {
      out print: "[:return, "
      @expr to_ruby_sexp: out
      out print: "]"
    }
  }
}
