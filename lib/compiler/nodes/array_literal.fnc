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

    def to_ruby_sexp: out {
      out print: "[:array_lit, ["
      @array each: |a| {
        a to_ruby_sexp: out
      } in_between: {
        out print: ", "
      }
      out print: "]]"
    }
  }
}
