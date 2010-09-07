def class AST {
  def class MethodDefinition : Node {
    self read_slots: ['method];

    def initialize: method {
      @method = method;
      @docstring = @method docstring
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
      @method args empty? if_false: {
        out print: "(";
        @method args from: 0 to: -2 . each: |a| {
          a to_ruby: out;
          out print: ","
        };
        @method args last if_do: |l| { out print: $ l name };
        out print: ")"
      };
      out newline;
      { @method body to_ruby: out indent: (ilvl + 2) } if: (@method body);
      out newline;
      out print: $ s ++ "end";
      out newline;
      @docstring if_do: {
        out print: $ (" " * ilvl) ++ "self.method('";
        @method ident to_ruby: out;
        out print: "').docstring = ";
        out print: $ "'" ++ @docstring ++ "'"
      };
      out newline
    }
  }
}
