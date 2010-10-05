module Fancy
  module AST

    class ArrayLiteral < Rubinius::AST::ArrayLiteral
      Nodes[:array_lit] = self
      attr_accessor :array
      def initialize(line, *array)
        super(line, array)
        @array = array
      end
    end

  end
end
