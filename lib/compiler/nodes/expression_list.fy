def class AST {
  def class ExpressionList : Node {
    read_slots: ['exprs]
    def initialize: exprs {
      @exprs = exprs
    }

    def ExpressionList from_sexp: sexp {
      ExpressionList new: $ sexp second map: 'to_ast
    }

    def to_s {
      "<ExpressionList: [" ++ (@exprs join: ",") ++ "]>"
    }

    def inspect {
      self to_s
    }

    def to_ruby_sexp: out {
      out print: "[:exp_list, "
      # output docstring as first expression
      {
        StringLiteral new: @docstring . to_ruby_sexp: out
        out print: ", "
      } if: @docstring

      @exprs each: |e| {
        e to_ruby_sexp: out
      } in_between: {
        out print: ", "
      }
      out print: "]"
    }

    def docstring {
      @docstring if_nil: {
        @exprs first is_a?: StringLiteral . if_true: {
          @docstring = @exprs first string
          @exprs = @exprs rest # remove docstring from @exprs
        }
      }
      @docstring
    }
  }
}
