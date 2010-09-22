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

    def to_ruby: out indent: ilvl {
      out print: "Proc.new{"
      @args empty? if_false: {
        out print: "|"
        @args each: |a| { a to_ruby: out } in_between: { out print: ", "}
        out print: "|"
      }
      out print: " "
      @body to_ruby: out
      out print: " }"
    }
  }
}
