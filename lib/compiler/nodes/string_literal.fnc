def class AST {
  def class StringLiteral : Node {
    self read_slots: ['string];
    def initialize: str {
      @string = str
    }

    def StringLiteral from_sexp: sexp {
      AST::StringLiteral new: $ sexp second
    }

    def to_ruby: out {
      out print: @string
    }
  }
}
