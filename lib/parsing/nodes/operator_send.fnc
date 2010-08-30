def class OperatorSend : Node {
  self read_write_slots: ['receiver, 'op_ident, 'operand];
  def OperatorSend receiver: recv op_ident: op_id operand: operand {
    os = OperatorSend new;
    os receiver: recv;
    os op_ident: op_id;
    os operand: operand;
    os
  }
}
