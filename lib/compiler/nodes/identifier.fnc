def class AST {
  def class Identifier : Node {
    self read_write_slots: ['name];
    def initialize: name {
      @name = name
    }

    def Identifier from_sexp: sexp {
      AST::Identifier new: $ sexp second
    }

    def to_s {
      "<Identifier: '" ++ @name ++ "'>"
    }

    def to_ruby: out {
      out print: $ self rubyfy
    }

    def rubyfy {
      @name to_s split: ":" . select: |x| { x empty? not } . join: "___"
    }
  }
}
