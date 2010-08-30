def class ExpressionList : Node {
  self read_write_slots: ['exprs];
  Node register: 'exp_list for_node: ExpressionList;
  def initialize: exprs {
    @exprs = exprs
  }

  def ExpressionList from_sexp: sexp {
    ExpressionList new: (sexp second map: |x| { x to_ast })
  }

  def to_s {
    "<ExpressionList: [" ++ (@exprs join: ",") ++ "]>"
  }
}
