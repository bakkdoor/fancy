def class AST {
  def class Assignment : Node {
    read_slots: ['ident, 'expr]

    def initialize: ident value: expr {
      @ident = ident
      @expr = expr
    }

    def Assignment from_sexp: sexp {
      Assignment new: (sexp second to_ast) value: (sexp third to_ast)
    }

    def to_ruby: out indent: ilvl {
      @ident to_ruby: out indent: ilvl
      out print: " = "
      @expr to_ruby: out
    }
  }
}
