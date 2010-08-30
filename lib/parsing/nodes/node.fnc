def class Array {
  def to_ast {
    self first is_a?: Symbol . if_true: {
      (Node ast_creators[self first]) if_do: |x| {
        x from_sexp: self
      } else: {
        "Node not defined: " ++ (self first) . raise!
      }
    } else: {
      "No node given!" raise!
    }
  }
};

def class Node {
  @@ast_creators = <[]>;

  def Node register: keyword for_node: node_class {
    @@ast_creators at: keyword put: node_class
  }

  def Node ast_creators {
    @@ast_creators
  }
}
