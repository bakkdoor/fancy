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

    def to_ruby: out indent: ilvl {
      s = " " * ilvl
      out print: $ s ++ "class "
      out print: $ @ident name
      { out print: " < "; @superclass_ident to_ruby: out indent: ilvl } if: @superclass_ident
      out newline

      ilvl = ilvl + 2

      @body to_ruby: out indent: ilvl
      out newline
      out print: $ s ++ "end"
    }
  }
}
