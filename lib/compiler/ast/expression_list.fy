class Fancy AST {

  class ExpressionList : Node {
    read_slots: ['expressions]
    def initialize: @line list: @expressions ([]) {}

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
      @expressions each: |expr| {
        size = size - 1
        expr bytecode: g
        { g pop() } if: (size > 0)
      }
    }

    # This method is only used by Rubinius' compiler classes and
    # defined to be able to use their bytecode generation toolchain.
    def strip_arguments {
      []
    }

    # If this expression list contains more than one expression
    # and the first one is an string literal, it'll be used as doc.
    # This method removes the first documentation string.
    def shift_docstring {
      if: ((@expressions first kind_of?(Rubinius AST StringLiteral)) && \
           (@expressions.size > 1)) then: {
        @expressions shift()
      }
    }

  }

}
