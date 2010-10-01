def class AST {
  def class ArrayLiteral : Node {
    """
    Represents array literals in Fancy.
    """

    read_slots: ['array]
    def initialize: array {
      @array = array
    }

    def ArrayLiteral from_sexp: sexp {
      ArrayLiteral new: $ sexp second
    }
  }
}
