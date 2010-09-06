def class AST {
  def class SingletonMethodDefinition : Node {
    self read_write_slots: ['object_ident, 'method];

    def SingletonMethodDefinition object_ident: obj_ident method: method {
      cd = AST::SingletonMethodDefinition new;
      cd object_ident: obj_ident;
      cd method: method;
      cd
    }

    def SingletonMethodDefinition from_sexp: sexp {
      obj_ident = sexp second to_ast;
      method = sexp third to_ast;
      AST::SingletonMethodDefinition object_ident: obj_ident method: method
    }
  }
}
