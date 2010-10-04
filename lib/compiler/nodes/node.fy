def class AST {
  def class Node {
    @@ast_creators = <[]>

    def self register: keyword for_node: node_class {
      @@ast_creators at: keyword put: node_class
    }

    def self ast_creators {
      @@ast_creators
    }
  }
}

def class Array {
  def to_ast {
    self first is_a?: Symbol . if_true: {
      (AST::Node ast_creators[self first]) if_do: |x| {
        x from_sexp: self
      } else: {
        "Node not defined: " ++ (self first) . raise!
      }
    } else: {
      "No node given!" raise!
    }
  }
}

