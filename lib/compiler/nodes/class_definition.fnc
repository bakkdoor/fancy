def class AST {
  def class ClassDefinition : Node {
    self read_write_slots: ['ident, 'superclass_ident, 'body];
    def ClassDefinition identifier: ident superclass: superclass_ident body: class_body {
      cd = ClassDefinition new;
      cd ident: ident;
      cd superclass_ident: superclass_ident;
      cd body: class_body;
      cd
    }

    def ClassDefinition from_sexp: sexp {
      ident = sexp second to_ast;
      superclass_ident = sexp third empty? if_false: { sexp third to_ast };
      body = sexp fourth to_ast;
      ClassDefinition identifier: ident superclass: superclass_ident body: body
    }

    def to_s {
      "<ClassDefinition: ident:'" ++ @ident ++ "' superclass:'" ++ @superclass_ident ++ "' body:" ++ @body ++ ">"
    }
  }
}
