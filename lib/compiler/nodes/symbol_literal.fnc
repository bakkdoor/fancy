def class AST {
  def class SymbolLiteral : Node {
    self read_slots: ['symbol];
    def initialize: sym {
      @symbol = sym
    }

    def SymbolLiteral from_sexp: sexp {
      AST::SymbolLiteral new: $ sexp second
    }

    def to_ruby: out indent: ilvl {
      (@symbol to_s include?: ":")
      || (@symbol == '||) . if_true: {
        out print: $ (" " * ilvl) ++ ":'" ++ @symbol ++ "'"
      } else: {
        out print: $ (" " * ilvl) ++ ":" ++ @symbol
      }
    }
  }
}
