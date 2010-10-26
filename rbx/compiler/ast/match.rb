module Fancy
  module AST

    class Match < Node
      def initialize(line, expr, body)
        super(line)
        @expr = expr
        @body = body
      end

      def bytecode(g)
        raise "Not implemented yet!"
      end
    end

  end
end
