class Fancy
  class AST

    class HashLiteral < Rubinius::ToolSet.current::TS::AST::HashLiteral
      def initialize(line, *array)
        super(line, array)
      end
    end

  end
end
