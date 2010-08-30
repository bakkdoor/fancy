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
require: "nodes/array_literal";

Node register: 'exp_list for_node: ExpressionList;
Node register: 'ident for_node: Identifier;

Node register: 'array_lit for_node: ArrayLiteral;
Node register: 'block_lit for_node: BlockLiteral;
Node register: 'int_lit for_node: BlockLiteral;
Node register: 'double_lit for_node: BlockLiteral;
Node register: 'string_lit for_node: StringLiteral;

Node register: 'class_def for_node: ClassDefinition;
Node register: 'message_send for_node: MessageSend;
Node register: 'operator_send for_node: OperatorSend;
Node register: 'method for_node: Method;
Node register: 'method_def for_node: MethodDefinition;
