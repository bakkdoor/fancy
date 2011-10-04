"""
  AST nodes are an object representation of source files.


  For example for a source code containing only the following expression:

     Console println: hello

  An AST tree like the following will be created:

     Script:
      @body: ExpressionList
        @expressions:
          - MessageSend
             @receiver:
               Constant @string: Console
             @name:
               Identifier @string: println:
             @args:
               - Identifier @string: hello
"""

require: "ast/node"
require: "ast/script"
require: "ast/expression_list"
require: "ast/identifier"
require: "ast/message_send"
require: "ast/future_send"
require: "ast/async_send"
require: "ast/method_def"
require: "ast/singleton_method_def"
require: "ast/super"
require: "ast/literals"
require: "ast/assign"
require: "ast/block"
require: "ast/class_def"
require: "ast/tuple_literal"
require: "ast/range"
require: "ast/match"
require: "ast/try_catch"
require: "ast/return"
require: "ast/string_interpolation"
