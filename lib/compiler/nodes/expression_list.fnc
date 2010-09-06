def class AST {
  def class ExpressionList : Node {
    self read_write_slots: ['exprs];
    def initialize: exprs {
      @exprs = exprs
    }

    def ExpressionList from_sexp: sexp {
      AST::ExpressionList new: $ sexp second map: 'to_ast
    }

    def to_s {
      "<ExpressionList: [" ++ (@exprs join: ",") ++ "]>"
    }

    def inspect {
      self to_s
    }

    def to_ruby: out {
      @exprs each: |e| {
        e to_ruby: out;
        out println: "; "
      }
    }
  }
}
