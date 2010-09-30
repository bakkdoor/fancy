module Fancy
  module AST

    class ExpressionList < Node

      name :exp_list

      def initialize(*expressions)
        @expressions = expressions
      end

      def bytecode(g)
        pos(g)
        g.push_scope
        @expressions.each do |expr|
          expr.bytecode(g)
        end
      end

    end

  end
end
