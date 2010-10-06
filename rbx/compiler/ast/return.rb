module Fancy
  module AST

    class Return < Node
      name :return

      def initialize(line, expr)
        super(line)
        @expr = expr
      end

      def bytecode(g)
        @expr.bytecode(g)
        g.raise_return
      end
    end

  end
end
