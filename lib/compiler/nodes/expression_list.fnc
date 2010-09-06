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

    def to_ruby: out indent: ilvl {
      @exprs from: 0 to: -2 . each: |e| {
        e to_ruby: out indent: ilvl;
        out print: "\n"
      };
      @exprs last to_ruby: out indent: ilvl
    }
  }
}
