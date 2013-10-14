class Fancy
  class AST

    class ExpressionList < Node
      attr_reader :expressions

      def initialize(line, *expressions)
        super(line)
        @expressions = expressions
      end

      def unshift_expression(expression)
        @expressions.unshift(expression)
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

      # If this expression list contains more than one expression
      # and the first one is an string literal, it'll be used as doc.
      # This method removes the first documentation string.
      def shift_docstring
        if expressions.first.kind_of?(Rubinius::ToolSet::Runtime::AST::StringLiteral) &&
            expressions.size > 1
          expressions.shift
        end
      end

    end

  end
end
