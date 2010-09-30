module Fancy
  module AST

    class StringLiteral < Node

      name :string_lit

      def initialize(string)
        @string = string
      end

    end

  end
end
