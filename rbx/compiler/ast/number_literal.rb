module Fancy
  module AST

    class IntLiteral < Node
      name :int_lit

      def initialize(line, val)
        super(line)
        @val = val
      end

      def bytecode(g)
        Rubinius::AST::FixnumLiteral.new(0, @val).bytecode(g)
      end
    end

    class DoubleLiteral < Node
      name :double_lit
      def initialize(line, val)
        super(line)
        @val = val
      end

      def bytecode(g)
        Rubinius::AST::FloatLiteral.new(0, @val).bytecode(g)
      end
    end

  end
end
