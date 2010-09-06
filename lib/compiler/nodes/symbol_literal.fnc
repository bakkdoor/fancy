def class AST {
  def class SymbolLiteral : Node {
    self read_slots: ['symbol];
    def initialize: sym {
      @symbol = sym
    }

    def SymbolLiteral from_sexp: sexp {
      AST::SymbolLiteral new: $ sexp second
    }

    def to_ruby: out {
      @symbol to_s include?: ":" . if_true: {
        out print: $ ":'" ++ @symbol ++ "'"
      } else: {
        out print: $ ":" ++ @symbol
      }
    }
  }
}
