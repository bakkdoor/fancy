def class AST {
  def class MethodDefinition : Node {
    self read_slots: ['method];

    def initialize: method {
      @method = method
    }

    def MethodDefinition from_sexp: sexp {
      AST::MethodDefinition new: (sexp second to_ast)
    }

    def to_s {
      "<MethodDefinition: method:" ++ @method ++ ">"
    }

    def to_ruby: out indent: ilvl {
      s = " " * ilvl;
      out print: $ s ++ "def ";

      @method ident to_ruby: out;
      out print: "(";
      @method args from: 0 to: -2 . each: |a| {
        a to_ruby: out;
        out print: ","
      };
      @method args last if_do: |l| { out print: $ l name };
      out println: ")";
      { @method body to_ruby: out indent: (ilvl + 2) } if: (@method body);

      out newline;
      out print: $ s ++ "end"
    }
  }
}
