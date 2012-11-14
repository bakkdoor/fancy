class Fancy AST {
  class MethodDef : Rubinius AST Define {
    def initialize: @line name: @name args: @arguments (MethodArgs new: @line) body: @body (ExpressionList new: @line) access: @access ('public) {
      { @body = ExpressionList new: @line } unless: @body
      @name = @name method_name: nil
      @docstring = @body docstring
      generate_ivar_assignment

      if: (@body empty?) then: {
        @body unshift_expression: $ NilLiteral new: @line
      }
    }

    def generate_ivar_assignment {
      @arguments required() reverse() each: |name| {
        if: (name to_s =~ /^@/) then: {
          ident = Identifier from: (name to_s) line: @line
          value = Rubinius AST LocalVariableAccess new(@line, name)
          asign = Assignment new: @line var: ident value: value
          @body unshift_expression: asign
        }
      }
    }

    def bytecode: g {
      pos(g)

      @name to_s =~ /^initialize:(\S)+/ if_true: {
        define_constructor_class_method: g
      }
      @name to_s =~ /^unknown_message:with_params:$/ if_true: {
        define_method_missing: g
      }

      bytecode(g)
      MethodDef set: g docstring: @docstring line: @line argnames: $ @arguments names()
    }

    # Sets fancy documentation for the object currently
    # on top of the stack
    def MethodDef set: g docstring: docstring line: line argnames: argnames {
      # prevent invoking documentation: when doesnt makes sense.
      { return nil } unless: docstring
      local = StackLocal new: line
      local set: g
      ms = MessageSend new: line \
                       message: (Identifier from: "for:is:" line: line) \
                       to: (Identifier from: "Fancy::Documentation" line: line) \
                       args: $ MessageArgs new: line args: [local, docstring]
      ms bytecode: g

      meta = HashLiteral new: line entries: [SymbolLiteral new: line value: 'argnames,
                                             ArrayLiteral new: line array: $ argnames map: |arg| { StringLiteral new: line value: $ arg to_s }]
      ms = MessageSend new: line \
                       message: (Identifier from: "meta:" line: line) \
                       to: (Nothing new: line) \
                       args: $ MessageArgs new: line args: [meta]
      ms bytecode: g
      g pop()
    }

    # defines a class method names "new:foo:" if we're defining a
    # method named e.g. "initialize:foo:" (a constructor method).
    def define_constructor_class_method: g {
      method_ident = StringLiteral new(@line, @name to_s from: 11 to: -1)
      ms = MessageSend new:     @line                                                             \
                       message: (Identifier from: "define_constructor_class_method:" line: @line) \
                       to:      (Self new: @line)                                                 \
                       args:    (MessageArgs new: @line args: [method_ident])
      ms bytecode: g
      g pop()
    }

    def define_method_missing: g {
      ms = MessageSend new:     @line                                                          \
                       message: (Identifier from: "define_forward_method_missing" line: @line) \
                       to:      (Self new: @line)                                              \
                       args:    (MessageArgs new: @line)
      ms bytecode: g
      g pop()
    }
  }

  class MethodArgs : Rubinius AST FormalArguments {
    def initialize: @line args: @array ([]) {
      initialize(@line, @array map() |a| { a to_sym() }, nil, nil)
    }
  }
}
