def class AST {
  def class Assignment : Node {
    self read_write_slots: ['ident, 'expr];

    def Assignment ident: ident value: expr {
      as = AST::Assignment new;
      as ident: ident;
      as expr: expr
    }

    def Assignment from_sexp: sexp {
      AST::Assignment ident: (sexp second to_ast) value: (sexp third to_ast)
    }

    def to_ruby: out indent: ilvl {
      @ident to_ruby: out indent: ilvl;
      out print: " = ";
      @expr to_ruby: out
    }
  }
}
