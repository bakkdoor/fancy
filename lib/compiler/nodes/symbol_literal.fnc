def class AST {
  def class SymbolLiteral : Node {
    self read_slots: ['symbol];
    def initialize: sym {
      @symbol = sym
    }

    def SymbolLiteral from_sexp: sexp {
      SymbolLiteral new: $ sexp second
    }
  }
}
