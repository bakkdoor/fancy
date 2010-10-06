require: "nodes/node"
require: "nodes/identifier"
require: "nodes/expression_list"
require: "nodes/class_definition"
require: "nodes/method"
require: "nodes/method_definition"
require: "nodes/singleton_method_definition"
require: "nodes/message_send"
require: "nodes/operator_send"
require: "nodes/block_literal"
require: "nodes/string_literal"
require: "nodes/symbol_literal"
require: "nodes/number_literal"
require: "nodes/array_literal"
require: "nodes/hash_literal"
require: "nodes/require"
require: "nodes/return"
require: "nodes/assignment"
require: "nodes/try_catch_block"
require: "nodes/ruby_args_literal"
require: "nodes/super"
require: "nodes/self"

AST::Node register: 'exp_list for_node: AST::ExpressionList
AST::Node register: 'ident for_node: AST::Identifier

AST::Node register: 'array_lit for_node: AST::ArrayLiteral
AST::Node register: 'hash_lit for_node: AST::HashLiteral
AST::Node register: 'block_lit for_node: AST::BlockLiteral
AST::Node register: 'int_lit for_node: AST::NumberLiteral
AST::Node register: 'double_lit for_node: AST::NumberLiteral
AST::Node register: 'string_lit for_node: AST::StringLiteral
AST::Node register: 'symbol_lit for_node: AST::SymbolLiteral

AST::Node register: 'class_def for_node: AST::ClassDefinition
AST::Node register: 'message_send for_node: AST::MessageSend
AST::Node register: 'operator_send for_node: AST::OperatorSend
AST::Node register: 'method for_node: AST::Method
AST::Node register: 'method_def for_node: AST::MethodDefinition
AST::Node register: 'singleton_method_def for_node: AST::SingletonMethodDefinition
AST::Node register: 'operator_def for_node: AST::MethodDefinition
AST::Node register: 'singleton_operator_def for_node: AST::SingletonMethodDefinition
AST::Node register: 'protected for_node: AST::ProtectedMethodDefinition
AST::Node register: 'private for_node: AST::PrivateMethodDefinition

AST::Node register: 'require for_node: AST::Require
AST::Node register: 'return for_node: AST::Return
AST::Node register: 'return_local for_node: AST::ReturnLocal
AST::Node register: 'assign for_node: AST::Assignment
AST::Node register: 'try_catch_block for_node: AST::TryCatchBlock
AST::Node register: 'except_handler for_node: AST::ExceptHandler

AST::Node register: 'rb_args_lit for_node: AST::RubyArgsLiteral

AST::Node register: 'super for_node: AST::Super
AST::Node register: 'self for_node: AST::Self
