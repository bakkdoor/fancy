def class AST {
  def class NumberLiteral : Node {
    self read_slots: ['num_val];
    def initialize: num_val {
      @num_val = num_val
    }

    def NumberLiteral from_sexp: sexp {
      NumberLiteral new: (sexp second)
    }

    def to_ruby: out indent: ilvl {
      out print: $ " " * ilvl;
      out print: @num_val
    }
  }
}
