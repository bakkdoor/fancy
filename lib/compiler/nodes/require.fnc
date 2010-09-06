def class AST {
  def class Require : Node {
    self read_slots: ['expr];
    def initialize: expr {
      @expr = expr
    }

    def Require from_sexp: sexp {
      AST::Require new: $ sexp second to_ast
    }
  }
}
