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
  }
}
