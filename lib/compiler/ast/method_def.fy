class Fancy AST {

  class MethodDef : Rubinius AST Define {
    def initialize: @line name: @name args: @arguments body: @body access: @access {
      @name = @name method_name: nil
      self generate_ivar_assignment

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
      g push_self()
      g send(@access, 0)
      g pop()

      # TODO: constructors and method_missing
      @name to_s =~ /^initialize:(\S)+/ if_do: {
        define_constructor_class_method: g
      }
      @name to_s =~ /^unknown_message:with_params:$/ if_do: {
        define_method_missing: g
      }

      # TODO: docstring
      bytecode(g)
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
    }

    def define_method_missing: g {
      ms = MessageSend new:     @line                                                          \
                       message: (Identifier from: "define_forward_method_missing" line: @line) \
                       to:      (Self new: @line)                                              \
                       args:    (MessageArgs new: @line args: [])
      ms bytecode: g
    }
  }

  class MethodArgs : Rubinius AST FormalArguments {
    def initialize: @line args: @array{
      initialize(@line, @array map() |a| { a to_sym() }, nil, nil)
    }
  }
}
