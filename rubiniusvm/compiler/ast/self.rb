module Fancy
  module AST

    # Self node uses Rubinius' Self AST node in the background.
    class Self < Node
      name :self

      def initialize(line)
        @self = Rubinius::AST::Self.new(line)
      end

      def bytecode(g)
        @self.bytecode g
      end
    end

  end
end
