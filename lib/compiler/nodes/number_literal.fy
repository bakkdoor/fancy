def class AST {
  def class NumberLiteral : Node {
    read_slots: ['num_val]
    def initialize: num_val is_int: is_int {
      @num_val = num_val
      @is_int = is_int
    }

    def NumberLiteral from_sexp: sexp {
      is_int = sexp first == 'int_lit
      NumberLiteral new: (sexp second) is_int: is_int
    }

    def to_ruby_sexp: out {
      @is_int if_true: {
        out print: "[:int_lit, "
      } else: {
        out print: "[:double_lit, "
      }
      out print: (@num_val inspect)
      out print: "]"
    }
  }
}
