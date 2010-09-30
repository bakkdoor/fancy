def class AST {
  def class StringLiteral : Node {
    read_slots: ['string]
    def initialize: str {
      @string = str
    }

    def StringLiteral from_sexp: sexp {
      StringLiteral new: $ sexp second
    }

    def to_ruby_sexp: out {
      out print: "[:string_lit, "
      out print: (@string inspect)
      out print: "]"
    }

    def to_ruby: out indent: ilvl{
      out print: $ " " * ilvl ++ (@string inspect)
    }
  }
}
