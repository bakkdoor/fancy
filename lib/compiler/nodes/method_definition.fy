def class AST {
  def class MethodDefinition : Node {
    read_slots: ['method]

    def is_protected: p {
      @method is_protected: p
    }

    def is_private: p {
      @method is_private: p
    }


    def initialize: method {
      @method = method
      @docstring = @method docstring
    }

    def MethodDefinition from_sexp: sexp {
      MethodDefinition new: (sexp second to_ast)
    }

    def to_s {
      "<MethodDefinition: method:" ++ @method ++ ">"
    }

    def to_ruby_sexp: out {
      out print: "[:method_def, "
      @method to_ruby_sexp: out
      out print: "]"
    }
  }

  def class ProtectedMethodDefinition : Node {
    def ProtectedMethodDefinition from_sexp: sexp {
      method_def = sexp second to_ast
      method_def is_protected: true
      method_def is_private: nil
      method_def
    }
  }

  def class PrivateMethodDefinition : Node {
    def PrivateMethodDefinition from_sexp: sexp {
      method_def = sexp second to_ast
      method_def is_protected: nil
      method_def is_private: true
      method_def
    }
  }
}
