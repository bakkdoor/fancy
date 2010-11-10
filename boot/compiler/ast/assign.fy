class Fancy AST {

  class Assignment : Node {
    def initialize: @rvalue to: @lvalue line: @line { super }

    def bytecode: g {
      @lvalue bytecode: g assign: @rvalue
    }
  }

  class Identifier {
    def bytecode: g assign: value {
      Rubinius AST LocalVariableAssignment new(@line, self name, value) bytecode(g)
    }
  }

  class InstanceVariable {
    def bytecode: g assign: value {
      Rubinius AST InstanceVariableAssignment new(@line, self name, value) bytecode(g)
    }
  }

  class ClassVariable {
    def bytecode: g assign: value {
      Rubinius AST ClassVariableAssignment new(@line, self name, value) bytecode(g)
    }
  }

  class Constant {
    def bytecode: g assign: value {
      Rubinius AST ConstantAssignment new(@line, self name, value) bytecode(g)
    }
  }

}
