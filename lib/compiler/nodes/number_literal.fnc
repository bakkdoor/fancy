def class NumberLiteral : Node {
  self read_slots: ['num_val];
  def initialize: num_val {
    @num_val = num_val
  }

  def NumberLiteral from_sexp: sexp {
    NumberLiteral new: (sexp second)
  }
}
