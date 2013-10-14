class Fancy AST {
  class ExpressionList : Node {
    read_slot: 'expressions

    def initialize: @line list: @expressions ([]);

    def unshift_expression: expression {
      @expressions unshift(expression)
    }

    def add_expression: expression {
      @expressions << expression
    }

    def empty? {
      @expressions empty?
    }

    def bytecode: g {
      pos(g)
      size = @expressions size
      @expressions each: @{ bytecode: g } in_between: { g pop() }
    }

    # This method is only used by Rubinius' compiler classes and
    # defined to be able to use their bytecode generation toolchain.
    def strip_arguments {
      []
    }

    def docstring {
      if: (@expressions first kind_of?(Rubinius ToolSet Runtime AST StringLiteral)) then: {
        @expressions first
      }
    }
  }
}
