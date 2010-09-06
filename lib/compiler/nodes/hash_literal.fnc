def class AST {
  def class HashLiteral : Node {
    self read_slots: ['entries];
    def initialize: hash_entries {
      @entries = hash_entries
    }

    def HashLiteral from_sexp: sexp {
      AST::HashLiteral new: $ sexp second map: |entry| { entry map: 'to_ast }
    }
  }
}
