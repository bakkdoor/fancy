def class BlockLiteral : Node {
  self read_write_slots: ['args, 'body];
  def BlockLiteral args: args body: body {
    bl = BlockLiteral new;
    bl args: args;
    bl body: body;
    bl
  }
}
