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
      s = " " * ilvl; # indent level
      out print: $ s ++ "def ";

      @method ident to_ruby: out;

      # output args, if any given
      @method args empty? if_false: {
        out print: "(";
        @method args each: |arg| {
          arg to_ruby: out
        } in_between: {
          out print: ","
        };
        out print: ")"
      };

      out newline;

      # output method's body
      { @method body to_ruby: out indent: (ilvl + 2) } if: (@method body);
      out print: $ s ++ "end";

      # docstring, if given
      @docstring if_do: {
        out newline;
        out print: $ (" " * ilvl) ++ "self.method('";
        @method ident to_ruby: out;
        out print: "').docstring = ";
        out print: $ @docstring inspect;
        out newline
      }
    }
  }
}
