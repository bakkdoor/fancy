def class AST {
  def class BlockLiteral : Node {
    self read_write_slots: ['args, 'body];
    def BlockLiteral args: args body: body {
      bl = BlockLiteral new;
      bl args: args;
      bl body: body;
      bl
    }

    def BlockLiteral from_sexp: sexp {
      args = sexp second map: 'to_ast;
      body = sexp third to_ast;
      BlockLiteral args: (args to_ast) body: (body to_ast)
    }
  }
}
