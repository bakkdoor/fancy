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
        size = @expressions.size
        @expressions.each do |expr|
          size -= 1
          expr.bytecode(g)
          g.pop if size > 0
        end
      end

      def empty?
        @expressions.size == 0
      end

      def strip_arguments
        []
      end
    end

  end
end
