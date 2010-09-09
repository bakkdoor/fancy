def class AST {
  def class StringLiteral : Node {
    read_slots: ['string];
    def initialize: str {
      @string = str
    }

    def StringLiteral from_sexp: sexp {
      StringLiteral new: $ sexp second
    }

    def to_ruby: out indent: ilvl{
      out print: $ " " * ilvl ++ (@string inspect)
    }
  }
}
