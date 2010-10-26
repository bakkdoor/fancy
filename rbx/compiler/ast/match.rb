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

    class MatchClause < Node
      def initialize(line, match_exp, val_exp)
        super(line)
        @match_exp = match_exp
        @val_exp = val_exp
      end
    end

  end
end
