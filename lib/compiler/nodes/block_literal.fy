def class AST {
  def class BlockLiteral : Node {
    """
    Represents block literals in Fancy.
    """

    read_slots: ['args, 'body]
    def initialize: args body: body {
      @args = args
      @body = body
    }

    def BlockLiteral from_sexp: sexp {
      args = sexp second map: 'to_ast
      body = sexp third to_ast
      BlockLiteral new: args body: body
    }

    def to_ruby_sexp: out {
      out print: "[:block_lit, [:block_args, "
      @args each: |a| {
        a to_ruby_sexp: out
      } in_between: {
        out print: ", "
      }
      out print: "], "
      @body to_ruby_sexp: out
      out print: "]"
    }
  }
}
