def class AST {
  def class MethodDefinition : Node {
    self read_slots: ['method];

    def initialize: method {
      @method = method
    }

    def MethodDefinition from_sexp: sexp {
      MethodDefinition new: (sexp second to_ast)
    }

    def to_s {
      "<MethodDefinition: method:" ++ @method ++ ">"
    }
  }
}
