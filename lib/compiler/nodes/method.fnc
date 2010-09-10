def class AST {
  def class Method : Node {
    read_write_slots: ['ident, 'args, 'body, 'is_protected, 'is_private]

    def Method identifier: ident args: args body: body {
      m = Method new
      m ident: ident
      m args: args
      m body: body
      m
    }

    def Method from_sexp: sexp {
      ident = Identifier new: (sexp second)
      args = sexp third map: 'to_ast
      body = sexp fourth to_ast
      Method identifier: ident args: args body: body
    }

    def to_s {
      "<Method: ident:'" ++ @ident ++ "' args:" ++ @args ++ " body:" ++ @body ++ ">"
    }

    def docstring {
      @body docstring
    }
  }
}
