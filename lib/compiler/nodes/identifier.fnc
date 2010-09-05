def class AST {
  def class Identifier : Node {
    self read_write_slots: ['name];
    def initialize: name {
      @name = name
    }

    def Identifier from_sexp: sexp {
      Identifier new: $ sexp second
    }

    def to_s {
      "<Identifier: '" ++ @name ++ "'>"
    }
  }
}
