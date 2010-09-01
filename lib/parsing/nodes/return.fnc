def class Return : Node {
  self read_slots: ['expr];
  def initialize: expr {
    @expr = expr
  }

  def Return from_sexp: sexp {
    Return new: $ sexp second to_ast
  }
}
