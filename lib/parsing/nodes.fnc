# def class UndefinedNodeError : Exception {
#   def initialize: node_name {
#     super initialize: $ "Node not defined: " ++ (node first)
#   }
# };

def class Array {
  def to_ast {
    self first is_a?: Symbol . if_true: {
      (Node ast_creators[self first]) if_do: |x| {
        x from_sexp: self
      } else: {
        Exception new: ("Node not defined: " ++ (node first)) . raise!
      }
    } else: {
      self map: :to_ast
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
};

def class Identifier : Node {
  self read_write_slots: [:name];
  Node register: :ident for_node: Identifier;
  def initialize: name {
    @name = name
  }

  def Identifier from_sexp: sexp {
    Identifier new: (sexp second)
  }

  def to_s {
    "<Identifier: '" ++ @name ++ "'>"
  }
};

def class ExpressionList : Node {
  self read_write_slots: [:exprs];
  Node register: :exp_list for_node: ExpressionList;
  def initialize: exprs {
    @exprs = exprs
  }

  def ExpressionList from_sexp: sexp {
    ExpressionList new: (sexp rest map: |x| { x to_ast })
  }

  def to_s {
    "<ExpressionList: [" ++ (@exprs join: ",") ++ "]>"
  }
};

def class ClassDefinition : Node {
  self read_write_slots: [:ident, :superclass_ident, :body];
  Node register: :class_def for_node: ClassDefinition;
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
};

def class Method : Node {
  self read_write_slots: [:ident, :args, :body];
  Node register: :method for_node: Method;
  def Method identifier: ident args: args body: body {
    m = Method new;
    m ident: ident;
    m args: args;
    m body: body;
    m
  }

  def Method from_sexp: sexp {
    ident = Identifier new: (sexp second);
    args = sexp third map: :to_ast;
    body = sexp fourth to_ast;
    Method identifier: ident args: args body: body
  }

  def to_s {
    "<Method: ident:'" ++ @ident ++ "' args:" ++ @args ++ " body:" ++ @body ++ ">"
  }
};

def class MethodDefinition : Node {
  self read_slots: [:method];
  Node register: :method_def for_node: MethodDefinition;
  def initialize: method {
    @method = method
  }

  def MethodDefinition from_sexp: sexp {
    MethodDefinition new: (sexp second to_ast)
  }

  def to_s {
    "<MethodDefinition: method:" ++ @method ++ ">"
  }
};

def class MessageSend : Node {
  self read_write_slots: [:receiver, :method_ident, :args];
  def MessageSend receiver: recv method_ident: mident args: args {
    ms = MessageSend new;
    ms receiver: recv;
    ms method_ident: mident;
    ms args: args;
    ms
  }
};

def class OperatorSend : Node {
  self read_write_slots: [:receiver, :op_ident, :operand];
  def OperatorSend receiver: recv op_ident: op_id operand: operand {
    os = OperatorSend new;
    os receiver: recv;
    os op_ident: op_id;
    os operand: operand;
    os
  }
};

def class BlockLiteral : Node {
  self read_write_slots: [:args, :body];
  def BlockLiteral args: args body: body {
    bl = BlockLiteral new;
    bl args: args;
    bl body: body;
    bl
  }
};

def class StringLiteral : Node {
  self read_slots: [:string];
  def initialize: str {
    @string = str
  }
};

def class NumberLiteral : Node {
  self read_slots: [:num_val];
  def initialize: num_val {
    @num_val = num_val
  }
};

# [:exp_list, [[:ident, "foo"]]] to_ast println
[:class_def, [:ident, "Block"], [:ident, "Object"],
 [:exp_list,
  [:method_def,
   [:method, "while_nil:", [[:ident, "block"]],
    [:exp_list,
     [[:ident, "nil"]]]]]]] to_ast println
