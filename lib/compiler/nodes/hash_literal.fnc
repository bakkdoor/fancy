def class AST {
  def class HashLiteral : Node {
    self read_slots: ['entries];
    def initialize: hash_entries {
      @entries = hash_entries
    }

    def HashLiteral from_sexp: sexp {
      HashLiteral new: $ sexp second map: |entry| { entry map: 'to_ast }
    }

    def to_ruby: out indent: ilvl {
      out print: $ " " * ilvl ++ "{";
      @entries from: 0 to: -2 . each: |e| {
        e first to_ruby: out;
        out print: " => ";
        e second to_ruby: out;
        out print: ", "
      };
      # output last entry without comma
      @entries last if_do: |l| {
        l first  to_ruby: out;
        out print: " => ";
        l second to_ruby: out
      };
      out print: "}"
    }
  }
}
