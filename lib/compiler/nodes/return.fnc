def class AST {
  def class Return : Node {
    read_slots: ['expr]
    def initialize: expr {
      @expr = expr
    }

    def Return from_sexp: sexp {
      Return new: $ sexp second to_ast
    }

    def to_ruby: out indent: ilvl {
      out print: $ " " * ilvl ++ "return "
      out print: (@expr to_ruby: out)
    }
  }
}
