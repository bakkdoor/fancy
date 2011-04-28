class Fancy AST {
  class ClassDef : Rubinius AST Class {
    def initialize: @line name: @name parent: @parent body: @body {
      name = nil
      if: (@name is_a?: NestedConstant) then: {
        name = @name scoped
      } else: {
        name = @name string to_sym()
      }

      if: (@body empty?) then: {
        @body unshift_expression: $ NilLiteral new: @line
      }

      initialize(@line, name, @parent, @body)
    }

    def bytecode: g {
      pos(g)
      docstring = body() body() shift_docstring
      docstring if_true: {
        setdoc = MessageSend new: @line \
                             message: (Identifier from: "for:append:" line: @line) \
                             to: (Identifier from: "Fancy::Documentation" line: @line) \
                             args: (MessageArgs new: @line args: [Self new: @line, docstring])

        # Replace first string expression to set documentation.
        body() body() unshift_expression: setdoc
      }
      bytecode(g)
    }
  }
}
