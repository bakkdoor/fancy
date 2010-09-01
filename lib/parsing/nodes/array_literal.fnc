def class ArrayLiteral : Node {
  self read_slots: ['array];
  def initialize: array {
    @array = array
  }

  def ArrayLiteral from_sexp: sexp {
    ArrayLiteral new: $ sexp second
  }
}
