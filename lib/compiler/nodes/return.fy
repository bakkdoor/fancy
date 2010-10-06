def class AST {
  def class Return : Node {
    read_slots: ['expr, 'is_local]
    def initialize: expr {
      @expr = expr
      @is_local = nil
    }

    def initialize: expr is_local: is_local {
      @expr = expr
      @is_local = is_local
    }

    def Return from_sexp: sexp {
      Return new: $ sexp second to_ast
    }

    def to_ruby_sexp: out {
      @is_local if_true: {
        out print: "[:return_local, "
      } else: {
        out print: "[:return, "
      }
      @expr to_ruby_sexp: out
      out print: "]"
    }
  }

  def class ReturnLocal : Node {
    def ReturnLocal from_sexp: sexp {
      Return new: (sexp second to_ast) is_local: true
    }
  }
}
