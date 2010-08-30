# def class UndefinedNodeError : StdError {
#   def initialize: node_name {
#     super initialize: $ "Node not defined: " ++ (node first)
#   }
# };

require: "nodes/node";
require: "nodes/identifier";
require: "nodes/expression_list";
require: "nodes/class_definition";
require: "nodes/method_definition";
require: "nodes/method";
require: "nodes/message_send";
require: "nodes/operator_send";
require: "nodes/block_literal";
require: "nodes/string_literal";
require: "nodes/number_literal";
require: "nodes/array_literal"

# example
#['exp_list, [['ident, "foo"]]] to_ast println;
#['exp_list, [['ident, "foo"], ['ident, "bar"]]] to_ast println;
# ['class_def, ['ident, "Block"], ['ident, "Object"],
#  ['exp_list,
#   [['method_def,
#     ['method, "while_nil:", [['ident, "block"]],
#      ['exp_list,
#       [['ident, "nil"]]]]]]]] to_ast println

# ['exp_list,
#  [['ident, "nil"]]] to_ast println
