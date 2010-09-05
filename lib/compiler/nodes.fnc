require: "nodes/node";
require: "nodes/identifier";
require: "nodes/expression_list";
require: "nodes/class_definition";
require: "nodes/method";
require: "nodes/method_definition";
require: "nodes/singleton_method_definition";
require: "nodes/message_send";
require: "nodes/operator_send";
require: "nodes/block_literal";
require: "nodes/string_literal";
require: "nodes/symbol_literal";
require: "nodes/number_literal";
require: "nodes/array_literal";
require: "nodes/hash_literal";
require: "nodes/require";
require: "nodes/return";
require: "nodes/assignment";

Node register: 'exp_list for_node: ExpressionList;
Node register: 'ident for_node: Identifier;

Node register: 'array_lit for_node: ArrayLiteral;
Node register: 'hash_lit for_node: HashLiteral;
Node register: 'block_lit for_node: BlockLiteral;
Node register: 'int_lit for_node: NumberLiteral;
Node register: 'double_lit for_node: NumberLiteral;
Node register: 'string_lit for_node: StringLiteral;
Node register: 'symbol_lit for_node: SymbolLiteral;

Node register: 'class_def for_node: ClassDefinition;
Node register: 'message_send for_node: MessageSend;
Node register: 'operator_send for_node: OperatorSend;
Node register: 'method for_node: Method;
Node register: 'method_def for_node: MethodDefinition;
Node register: 'singleton_method_def for_node: SingletonMethodDefinition;

Node register: 'require for_node: Require;
Node register: 'return for_node: Return;
Node register: 'assign for_node: Assignment;
