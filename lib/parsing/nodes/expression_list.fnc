def class ExpressionList : Node {
  self read_write_slots: ['exprs];
  def initialize: exprs {
    @exprs = exprs
  }

  def ExpressionList from_sexp: sexp {
    ExpressionList new: (sexp second map: |x| { x to_ast })
  }

  def to_s {
    "<ExpressionList: [" ++ (@exprs join: ",") ++ "]>"
  }

  def inspect {
    self to_s
  }
}
