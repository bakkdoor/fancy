def class AST {
  def class Require : Node {
    read_slots: ['expr];
    def initialize: expr {
      @expr = expr
    }

    def Require from_sexp: sexp {
      Require new: $ sexp second to_ast
    }

    def to_ruby: out indent: ilvl {
      out print: $ " " * ilvl ++ "require ";
      @expr to_ruby: out
    }
  }
}
