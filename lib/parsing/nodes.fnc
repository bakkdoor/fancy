def class Node {
};

def class Identifier : Node {
  self read_write_slots: [:name];
  def initialize: name {
    @name = name
  }
};

def class ExpressionList : Node {
  self read_write_slots: [:exprs];
  def initialize: exprs {
    @exprs = exprs
  }
};

def class ClassDefinition : Node {
  self read_write_slots: [:ident, :superclass_ident, :body];
  def ClassDefinition identifier: ident superclass: superclass_ident body: class_body {
    cd = ClassDefinition new;
    cd ident: ident;
    cd superclass_ident: superclass_ident;
    cd body: class_body;
    cd
  }
};

def class Method : Node {
  self read_write_slots: [:ident, :args, :body];
  def Method identifier: ident args: args body: body {
    m = Method new;
    m ident: ident;
    m args: args;
    m body: body;
    m
  }
};

def class MethodDefinition : Node {
  self read_slots: [:method];
  def initialize: method {
    @method = method
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
}
