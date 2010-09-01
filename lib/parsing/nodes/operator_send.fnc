def class OperatorSend : Node {
  self read_write_slots: ['receiver, 'op_ident, 'operand];
  def OperatorSend receiver: recv op_ident: op_id operand: operand {
    os = OperatorSend new;
    os receiver: recv;
    os op_ident: op_id;
    os operand: operand;
    os
  }

  def OperatorSend from_sexp: sexp {
    receiver = sexp[1] to_ast;
    op_ident = sexp[2] to_ast;
    operand = sexp[3] to_ast;
    OperatorSend receiver: receiver op_ident: op_ident operand: operand
  }

}
