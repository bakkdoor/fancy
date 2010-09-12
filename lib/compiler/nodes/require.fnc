def class AST {
  def class Require : Node {
    read_slots: ['expr]
    def initialize: expr {
      @expr = expr
    }

    def Require from_sexp: sexp {
      Require new: $ sexp second to_ast
    }

    def to_ruby: out indent: ilvl {
      ending = ".fnc.rb"
      out print: $ " " * ilvl ++ "require ("
      @expr to_ruby: out
      out print: $ " + " ++ (ending inspect) ++ ")"
    }
  }
}
