class Fancy
  class AST

    class Assignment < Node
      def initialize(line, ident, value)
        super(line)
        @ident = ident
        @value = value
      end

      def bytecode(g)
        if Rubinius::AST::ScopedConstant === @ident || @ident.constant?
          Rubinius::AST::ConstantAssignment.new(line, @ident.name, @value).bytecode(g)
        elsif @ident.instance_variable?
          Rubinius::AST::InstanceVariableAssignment.new(line, @ident.name, @value).
            bytecode(g)
        elsif @ident.class_variable?
          Rubinius::AST::ClassVariableAssignment.new(line, @ident.name, @value).
            bytecode(g)
        else
          Rubinius::AST::LocalVariableAssignment.new(line, @ident.name, @value).
            bytecode(g)
        end
      end
    end

    class MultipleAssignment < Node

      class MultipleAssignmentExpr < Node
        def initialize(line)
          super(line)
        end
        def bytecode(g)
          g.shift_array
        end
      end

      def initialize(line, idents, values)
        super(line)
        @idents = idents
        @values = values
      end

      def bytecode(g)
        @values.each do |val|
          val.bytecode(g)
        end
        g.make_array @values.size
        @idents.each do |ident|
          Assignment.new(@line, ident, MultipleAssignmentExpr.new(@line)).bytecode(g)
          g.pop
        end
      end
    end

  end
end
