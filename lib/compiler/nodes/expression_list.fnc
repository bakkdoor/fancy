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
      @exprs empty? if_false: {
        @exprs from: 0 to: -2 . each: |e| {
          e to_ruby: out indent: ilvl;
          out newline
        };
        @exprs last to_ruby: out indent: ilvl
      }
    }
    def docstring {
      @docstring if_nil: {
        @exprs first is_a?: AST::StringLiteral . if_true: {
          @docstring = @exprs first string;
          @exprs = @exprs rest # remove docstring from @exprs
        }
      };
      @docstring
    }
  }
}
