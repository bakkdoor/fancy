def class AST {
  def class SingletonMethodDefinition : Node {
    self read_write_slots: ['object_ident, 'method];

    def init_docstring {
      @docstring = @method docstring
    }

    def SingletonMethodDefinition object_ident: obj_ident method: method {
      cd = SingletonMethodDefinition new;
      cd object_ident: obj_ident;
      cd method: method;
      cd init_docstring;
      cd
    }

    def SingletonMethodDefinition from_sexp: sexp {
      obj_ident = sexp second to_ast;
      method = sexp third to_ast;
      SingletonMethodDefinition object_ident: obj_ident method: method
    }

    def to_ruby: out indent: ilvl {
      s = " " * ilvl;
      out print: $ s ++ "def ";

      @object_ident to_ruby: out;
      out print: ".";

      MethodDefinition output: out method: @method indent: ilvl;

      MethodDefinition output: out docstring: @docstring for: @object_ident method: (@method ident) indent: ilvl
    }
  }
}
