def class AST {
  def class SymbolLiteral : Node {
    read_slots: ['symbol]
    def initialize: sym {
      @symbol = sym
    }

    def SymbolLiteral from_sexp: sexp {
      SymbolLiteral new: $ sexp second
    }

    def to_ruby_sexp: out {
      out print: "[:symbol_lit, "

      (@symbol to_s include?: ":") .
      || (@symbol == '||) . if_true: {
        out print: $ ":'" ++ @symbol ++ "'"
      } else: {
        out print: $ ":" ++ @symbol
      }

      out print: "]"
    }
  }
}
