module Fancy
  module AST

    class Assignment < Node
      name :assign

      def initialize(line, ident, value)
        super(line)
        @ident = ident
        @value = value
      end

      def bytecode(g)
        if @ident.constant?
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

  end
end
