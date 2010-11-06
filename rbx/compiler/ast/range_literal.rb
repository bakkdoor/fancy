module Fancy
  module AST

    class RangeLiteral < Node
      attr_accessor :from, :to
      def initialize(line, from, to)
        super(line)
        @from = from
        @to = to
      end

      def bytecode(g)
        ms = MessageSend.new(@line,
                             Identifier.new(@line, "Range"),
                             Identifier.new(@line, "new:to:"),
                             MessageArgs.new(@line, @from, @to))
        ms.bytecode(g)
      end
    end

  end
end
