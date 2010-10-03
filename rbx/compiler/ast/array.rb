module Fancy
  module AST

    class ArrayLiteral < Rubinius::AST::ArrayLiteral
      Nodes[:array_lit] = self

      def initialize(line, *array)
        super(line, array)
      end
    end

  end
end
