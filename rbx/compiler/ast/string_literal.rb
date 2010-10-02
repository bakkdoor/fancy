module Fancy
  module AST

    class StringLiteral < Node
      name :string_lit

      def initialize(line, string)
        super(line)
        @string = string
      end

      def bytecode(g)
        # pos(g)
        # # TODO: change to push_unique_literal
        # g.push_literal @string
        # g.string_dup
        Rubinius::AST::StringLiteral.new(0, @string).bytecode(g)
      end

    end

  end
end
