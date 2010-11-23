class Fancy AST {
  class ClassDef : Rubinius AST Class {
    def initialize: @line name: @name parent: @parent body: @body {
      name = nil
      if: (@name is_a?: NestedConstant) then: {
        name = @name scoped
      } else: {
        name = @name string to_sym()
      }
      initialize(@line, name, @parent, @body)
    }

    def bytecode: g {
      # docstring = body() body() shift_docstring()
      # docstring if_do: {
      #   setdoc = MessageSend.new(line,
      #                            Identifier.new(line, "Fancy::Documentation"),
      #                            Identifier.new(line, "for:append:"),
      #                            MessageArgs.new(line,
      #                                            Rubinius::AST::Self.new(line),
      #                                            docstring))
      #   # Replace first string expression to set documentation.
      #   body body expressions unshift setdoc
      # }
      bytecode(g)
    }
  }
}
