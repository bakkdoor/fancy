module Fancy
  module AST
    class ExpressionList
      def to_ast
        [car.to_ast, *cdr]
      end
    end

    class Identifier
      def to_ast
        [:id, id]
      end
    end

    class IntegerLiteral
      def to_ast
        [:int, n.to_i(base)]
      end
    end

    class FloatLiteral
      def to_ast
        [:float, Float(n)]
      end
    end

    class SymbolLiteral
      def to_ast
        [:sym, text]
      end
    end

    class StringLiteral
      def to_ast
        [:str, text]
      end
    end

    class ArrayLiteral
      def to_ast
        [:arr, elements.map(&:to_ast)]
      end
    end

    class Code
      def to_ast
        [:code, code.to_ast]
      end
    end

    class Assignment
      def to_ast
        [:assign, id.to_ast, obj.to_ast]
      end
    end
  end
end
