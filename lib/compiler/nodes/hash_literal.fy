def class AST {
  def class HashLiteral : Node {
    """
    Represents hash literals in Fancy.
    """

    read_slots: ['entries]
    def initialize: hash_entries {
      @entries = hash_entries
    }

    def HashLiteral from_sexp: sexp {
      HashLiteral new: $ sexp second map: |entry| { entry map: 'to_ast }
    }

    def to_ruby_sexp: out {
      out print: "[:hash_lit, "
      @entries each: |e| {
        e first to_ruby_sexp: out
        out print: ", "
        e second to_ruby_sexp: out
      } in_between: {
        out print: ", "
      }
      out print: "]"
    }
  }
}
