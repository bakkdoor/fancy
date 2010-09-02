def class Assignment : Node {
  self read_slots: ['ident, 'expr];

  def Assignment ident: ident value: expr {
    as = Assignment new;
    as ident: ident;
    as expr: expr
  }

  def Assignment from_sexp: sexp {
    Assignment ident: (sexp second to_ast) value: (sexp third to_ast)
  }
}

