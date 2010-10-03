module Fancy
  module AST

    class ExpressionList < Node
      name :exp_list

      def initialize(line, *expressions)
        super(line)
        @expressions = expressions
      end

      def bytecode(g)
        pos(g)
        @expressions.each do |expr|
          expr.bytecode(g)
        end
      end
    end

  end
end
