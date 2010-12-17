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
      def initialize: @line {
      }

      def bytecode: g {
        pos(g)
        g shift_array()
      }
    }

    def initialize: @line var: @idents value: @values {
    }

    def bytecode: g {
      pos(g)
      @values each: |val| {
        val.bytecode(g)
      }
      g make_array(@values size)

      @idents each: |ident| {
        Assignment new: @line var: ident value: (MultipleAssignmentExpr new: @line) . bytecode: g
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
