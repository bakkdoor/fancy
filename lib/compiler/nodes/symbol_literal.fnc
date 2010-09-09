def class AST {
  def class SymbolLiteral : Node {
    read_slots: ['symbol];
    def initialize: sym {
      @symbol = sym
    }

    def SymbolLiteral from_sexp: sexp {
      SymbolLiteral new: $ sexp second
    }

    def to_ruby: out indent: ilvl {
      (@symbol to_s include?: ":") .
      || (@symbol == '||) . if_true: {
        out print: $ (" " * ilvl) ++ ":'" ++ @symbol ++ "'"
      } else: {
        out print: $ (" " * ilvl) ++ ":" ++ @symbol
      }
    }
  }
}
