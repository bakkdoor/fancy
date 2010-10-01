def class AST {
  def class ClassDefinition : Node {
    """
    Represents class definitions in Fancy.
    """

    read_slots: ['ident, 'superclass_ident, 'body]
    def initialize: ident superclass: superclass_ident body: class_body {
      @ident = ident
      @superclass_ident = superclass_ident
      @body = class_body
    }

    def ClassDefinition from_sexp: sexp {
      ident = sexp second to_ast
      superclass_ident = sexp third empty? if_false: { sexp third to_ast }
      body = sexp fourth to_ast
      ClassDefinition new: ident superclass: superclass_ident body: body
    }

    def to_s {
      "<ClassDefinition: ident:'" ++ @ident ++ "' superclass:'" ++ @superclass_ident ++ "' body:" ++ @body ++ ">"
    }

    def to_ruby_sexp: out {
      out print: "[:class_def, "
      @ident to_ruby_sexp: out
      out print: ", "
      @superclass_ident if_do: {
        @superclass_ident to_ruby_sexp: out
      } else: {
        out print: "[]"
      }
      out print: ", "
      @body to_ruby_sexp: out
      out print: "]"
    }
  }
}
