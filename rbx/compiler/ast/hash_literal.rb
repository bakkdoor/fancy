module Fancy
  module AST

    class HashLiteral < Rubinius::AST::HashLiteral
      Nodes[:hash_lit] = self

      def initialize(line, *array)
        super(line, array)
      end
    end

  end
end
