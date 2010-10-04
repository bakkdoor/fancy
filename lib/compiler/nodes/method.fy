def class AST {
  def class Method : Node {
    read_slots: ['ident, 'args, 'body]
    read_write_slots: ['is_protected, 'is_private]

    def initialize: ident args: args body: body {
      @ident = ident
      @args = args
      @body = body
    }

    def Method from_sexp: sexp {
      ident = Identifier new: (sexp second)
      args = sexp third map: 'to_ast
      body = sexp fourth to_ast
      Method new: ident args: args body: body
    }

    def to_s {
      "<Method: ident:'" ++ @ident ++ "' args:" ++ @args ++ " body:" ++ @body ++ ">"
    }

    def docstring {
      @body docstring
    }

    def to_ruby_sexp: out {
      @ident to_ruby_sexp: out
      out print: ", [:args, "
      @args each: |a| {
        out print: $ a name to_s inspect
      } in_between: {
        out print: ", "
      }
      out print: "], "
      @body to_ruby_sexp: out
    }
  }
}
