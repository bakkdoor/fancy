def class AST {
  def class SingletonMethodDefinition : Node {
    self read_write_slots: ['object_ident, 'method];

    def init_docstring {
      @docstring = @method docstring
    }

    def SingletonMethodDefinition object_ident: obj_ident method: method {
      cd = AST::SingletonMethodDefinition new;
      cd object_ident: obj_ident;
      cd method: method;
      cd init_docstring;
      cd
    }

    def SingletonMethodDefinition from_sexp: sexp {
      obj_ident = sexp second to_ast;
      method = sexp third to_ast;
      AST::SingletonMethodDefinition object_ident: obj_ident method: method
    }

    def to_ruby: out indent: ilvl {
      s = " " * ilvl;
      out print: $ s ++ "def ";
      @object_ident to_ruby: out;
      out print: ".";
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
        out print: $ (" " * ilvl);
        @object_ident to_ruby: out;
        out print: ".method('";
        @method ident to_ruby: out;
        out print: "').docstring = ";
        out print: $ @docstring inspect;
        out newline
      }
    }
  }
}
