class Fancy AST {
  class Assignment : Node {
    def initialize: @line var: @lvalue value: @rvalue

    def bytecode: g {
      pos(g)
      @lvalue bytecode: g assign: @rvalue
    }
  }

  class MultipleAssignment : Node {
    class MultipleAssignmentExpr : Node {
      def initialize: @line index: @index

      def bytecode: g {
        pos(g)
        margs = MessageArgs new: @line args: [FixnumLiteral new: @line value: @index]
        recv = StackTop new: @line
        msg = Identifier from: "at:" line: @line
        MessageSend new: @line message: msg to: recv args: margs . bytecode: g
      }
    }

    class SplatAssignmentExpr : Node {
      def initialize: @line start_index: @start_index

      def bytecode: g {
        pos(g)
        margs = MessageArgs new: @line args: [FixnumLiteral new: @line value: @start_index, FixnumLiteral new: @line value: -1]
        recv = StackTop new: @line
        msg = Identifier from: "from:to:" line: @line
        MessageSend new: @line message: msg to: recv args: margs . bytecode: g
      }
    }

    def initialize: @line var: @idents value: @values

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

      max_idx  = @idents size - 1
      @idents each_with_index: |ident idx| {
        var = ident
        value = MultipleAssignmentExpr new: @line index: idx
        match ident string {
          case /^\*/ ->
            value = SplatAssignmentExpr new: @line start_index: idx
            var = Identifier from: (ident string rest) line: (ident line)
        }
        Assignment new: @line var: var value: value . bytecode: g
        g pop()
      }
    }
  }

  class Identifier {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST LocalVariableAssignment new(@line, name, value) bytecode(g)
    }
  }

  class InstanceVariable {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST InstanceVariableAssignment new(@line, name, value) bytecode(g)
    }
  }

  class ClassVariable {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST ClassVariableAssignment new(@line, name, value) bytecode(g)
    }
  }

  class Constant {
    def bytecode: g assign: value {
      pos(g)
      Rubinius AST ConstantAssignment new(@line, name, value) bytecode(g)
    }
  }

  class DynamicVariable {
    def bytecode: g assign: value {
      pos(g)
      var = DynamicVariable new: @line string: @string
      dva = DynamicVariableAssign new: @line varname: var value: value in: (NilLiteral new: @line)
      dva bytecode: g
    }
  }

  class DynamicVariableAssign : Node {
    def initialize: @line varname: @varname value: @value in: @block {
       @varname = @varname varname
    }

    def bytecode: g {
      pos(g)

      ms = MessageSend new: @line \
                       message: (Identifier from: "let:be:in:" line: @line) \
                       to: (Self new: @line) \
                       args: (MessageArgs new: @line args: [@varname, @value, @block])
      ms bytecode: g
    }
  }
}
