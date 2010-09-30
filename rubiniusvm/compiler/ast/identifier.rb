module Fancy
  module AST

    class Identifier < Node

      name :identifier

      def initialize(identifier)
        @identifier = identifier
      end

    end

  end
end
