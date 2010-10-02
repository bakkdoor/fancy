module Fancy
  module AST

    class Assignment < Node
      name :assign

      def initialize(line, ident, value)
        super(line)
        @name = ident.name
        @value = value
      end

      def bytecode(g)
        Rubinius::AST::LocalVariableAssignment.new(line, @name, @value).bytecode(g)
      end
    end

  end
end
