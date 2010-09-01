def class StringLiteral : Node {
  self read_slots: ['string];
  def initialize: str {
    @string = str
  }

  def StringLiteral from_sexp: sexp {
    StringLiteral new: $ sexp second
  }
}
