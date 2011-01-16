class Fancy AST {

  class Assignment : Node {
    def initialize: @line var: @lvalue value: @rvalue { }

    def bytecode: g {
      pos(g)
      @lvalue bytecode: g assign: @rvalue
    }
  }

  class MultipleAssignment : Node {
    class MultipleAssignmentExpr : Node {
      def initialize: @line index: @index {
      }

      def bytecode: g {
        pos(g)
        margs = MessageArgs new: @line args: [FixnumLiteral new: @line value: @index]
        recv = StackTop new: @line
        msg = Identifier from: "at:" line: @line
        MessageSend new: @line message: msg to: recv args: margs . bytecode: g
      }
    }

    def initialize: @line var: @idents value: @values {
    }

    def bytecode: g {
      pos(g)
      if: (@values size > 1) then: {
        ArrayLiteral new: @line array: @values . bytecode: g
      } else: {
        # in this case we just have one value for multi-assign
        # so we expect it to be a collection type and get values by
        # calling "at:" method (see above)
        @values first bytecode: g
      }

      @idents each_with_index: |ident idx| {
        Assignment new: @line var: ident value: (MultipleAssignmentExpr new: @line index: idx) . bytecode: g
        g pop()
      }
    }
  }

  class Identifier {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST LocalVariableAssignment new(@line, self name, value) bytecode(g)
    }
  }

  class InstanceVariable {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST InstanceVariableAssignment new(@line, self name, value) bytecode(g)
    }
  }

  class ClassVariable {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST ClassVariableAssignment new(@line, self name, value) bytecode(g)
    }
  }

  class Constant {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST ConstantAssignment new(@line, self name, value) bytecode(g)
    }
  }

}
