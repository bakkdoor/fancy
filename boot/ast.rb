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

    class HashLiteral
      def to_ast
        [:hash, Hash[kvl.map{|k,v| [k.to_ast, v.to_ast] }]]
      end
    end

    class BlockLiteral
      def to_ast
        [:block, args, body]
      end
    end

    class Returns
      def to_ast
        if obj.respond_to?(:to_ast)
          [:ret, obj.to_ast]
        else
          [:ret, obj]
        end
      end
    end

    class ReturnsLocal
      def to_ast
        if obj.respond_to?(:to_ast)
          [:retl, obj.to_ast]
        else
          [:retl, obj]
        end
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

    class RegexLiteral
      def to_ast
        [:regex, Regexp.new(text.to_s), flags]
      end
    end

    class TupleLiteral
      def to_ast
        [:tuple, elements.map(&:to_ast)]
      end
    end

    class RangeLiteral
      def to_ast
        [:range, from.to_ast, to.to_ast]
      end
    end
  end
end
