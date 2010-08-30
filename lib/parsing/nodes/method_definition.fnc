def class MethodDefinition : Node {
  self read_slots: ['method];
  Node register: 'method_def for_node: MethodDefinition;
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
