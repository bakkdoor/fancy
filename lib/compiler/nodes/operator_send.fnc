def class AST {
  def class OperatorSend : Node {
    self read_write_slots: ['receiver, 'op_ident, 'operand];
    def OperatorSend receiver: recv op_ident: op_id operand: operand {
      os = AST::OperatorSend new;
      os receiver: recv;
      os op_ident: op_id;
      os operand: operand;
      os
    }

    def OperatorSend from_sexp: sexp {
      receiver = sexp[1] to_ast;
      op_ident = sexp[2] to_ast;
      operand = sexp[3] to_ast;
      AST::OperatorSend receiver: receiver op_ident: op_ident operand: operand
    }

    def to_ruby: out {
      @receiver to_ruby: out;
      out print: ".";
      @op_ident to_ruby: out;
      out print: "(";
      # output all but last args first, each followed by a comma
      @operand to_ruby: out;
      out print: ")"
    }
  }
}
