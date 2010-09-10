def class AST {
  def class OperatorSend : Node {
    read_slots: ['receiver, 'op_ident, 'operand]
    def initialize: recv op_ident: op_id operand: operand {
      @receiver = recv
      @op_ident = op_id
      @operand = operand
    }

    def OperatorSend from_sexp: sexp {
      receiver = sexp[1] to_ast
      op_ident = sexp[2] to_ast
      operand = sexp[3] to_ast
      OperatorSend new: receiver op_ident: op_ident operand: operand
    }

    def to_ruby: out indent: ilvl {
      name = @op_ident rubyfy
      ["and", "or", "not_equal", "plusplus"] any?: |x| { name == x } . if_true: {
        MessageSend new: @receiver method_ident: @op_ident args: [@operand] . to_ruby: out indent: ilvl
      } else: {
        out print: $ " " * ilvl ++ "("
        @receiver to_ruby: out

        # check for [] access
        # e.g.: arr[1] instead of: arr [] 1
        @op_ident name == '[] if_true: {
          out print: "["
          @operand to_ruby: out
          out print: "]"
        } else: {
          out print: " "
          @op_ident to_ruby: out
          out print: " "
          # output all but last args first, each followed by a comma
          @operand to_ruby: out
        }
        out print: ")"
      }
    }
  }
}
