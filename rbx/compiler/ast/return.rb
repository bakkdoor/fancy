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

    class ReturnLocal < Node
      name :return_local

      def initialize(line, expr)
        super(line)
        @expr = expr
      end

      def bytecode(g)
        @expr.bytecode(g)
        g.ret
      end
    end

  end
end
