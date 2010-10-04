def class AST {
  def class Assignment : Node {
    """
    Represents assignments in Fancy.
    """

    read_slots: ['ident, 'expr]

    def initialize: ident value: expr {
      @ident = ident
      @expr = expr
    }

    def Assignment from_sexp: sexp {
      Assignment new: (sexp second to_ast) value: (sexp third to_ast)
    }

    def to_ruby_sexp: out {
      out print: "[:assign, "
      @ident to_ruby_sexp: out
      out print: ", "
      @expr to_ruby_sexp: out
      out print: "]"
    }

  }
}
