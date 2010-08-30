def class Identifier : Node {
  self read_write_slots: ['name];
  Node register: 'ident for_node: Identifier;
  def initialize: name {
    @name = name
  }

  def Identifier from_sexp: sexp {
    Identifier new: (sexp second)
  }

  def to_s {
    "<Identifier: '" ++ @name ++ "'>"
  }
}
