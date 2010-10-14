module Fancy
  module AST

    class ExpressionList < Node
      name :exp_list

      def initialize(line, *expressions)
        super(line)
        @expressions = expressions
      end

      def add_expression(expression)
        @expressions << expression
      end

      def empty?
        @expressions.empty?
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

      # This method is only used by Rubinius' compiler classes and
      # defined to be able to use their bytecode generation toolchain.
      def strip_arguments
        []
      end
    end

  end
end
