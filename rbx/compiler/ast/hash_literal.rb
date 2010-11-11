class Fancy
  class AST

    class HashLiteral < Rubinius::AST::HashLiteral
      def initialize(line, *array)
        super(line, array)
      end
    end

  end
end
